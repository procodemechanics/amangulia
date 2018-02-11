#include <lib6lowpan/ip.h>
#include "sensing.h"
#include "blip_printf.h"

module MusicP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;

		interface UDP as Publish;
		interface UDP as LightSend;
		interface UDP as Settings;

		interface ShellCommand as GetCmd;
		interface ShellCommand as SetCmd;

		interface Timer<TMilli> as SensorReadTimer;
		interface Read<uint16_t> as ReadPar;

		interface Mount as ConfigMount;
		interface ConfigStorage;
	}
} implementation {

	enum {
		LOW_LIGHT_THRESHOLD = 50,
		PERIOD = 500, // ms
		DRUM = 1,
	};

	settings_t settings;
	uint32_t m_seq = 0;
	uint16_t m_par;
	bool single;
	nx_struct sensing_report stats;
	struct sockaddr_in6 route_dest;
	struct sockaddr_in6 multicast1;
	struct sockaddr_in6 multicast2;

	event void Boot.booted() {
		single = TRUE;

		settings.light_threshold = LOW_LIGHT_THRESHOLD;
		settings.instrument = DRUM;

		route_dest.sin6_port = htons(7000);
		inet_pton6(REPORT_DEST, &route_dest.sin6_addr);

		multicast1.sin6_port = htons(4000);
		inet_pton6(MULTICAST, &multicast1.sin6_addr);
		call Settings.bind(4000);

		multicast2.sin6_port = htons(4040);
		inet_pton6(MULTICAST, &multicast2.sin6_addr);
		call LightSend.bind(4040);

		call ConfigMount.mount();

		//call RadioControl.start();
	}

	//radio
	event void RadioControl.startDone(error_t e) {
		call SensorReadTimer.startPeriodic(PERIOD);
	}
	event void RadioControl.stopDone(error_t e) {}



	//config

	event void ConfigMount.mountDone(error_t e) {
		if (e != SUCCESS) {
			call Leds.led0On();
			call RadioControl.start();
		} else {
			if (call ConfigStorage.valid()) {
				call ConfigStorage.read(0, &settings, sizeof(settings));
			} else {
				settings.light_threshold = LOW_LIGHT_THRESHOLD;
				settings.instrument = DRUM;
				call RadioControl.start();
			}
		}
	}

	event void ConfigStorage.readDone(storage_addr_t addr, void* buf, storage_len_t len, error_t e) {
		call RadioControl.start();
	}

	event void ConfigStorage.writeDone(storage_addr_t addr, void* buf, storage_len_t len, error_t e) {
		call ConfigStorage.commit();
	}

	event void ConfigStorage.commitDone(error_t error) {}


	//udp interfaces

	event void Publish.recvfrom(struct sockaddr_in6 *from, void *data, uint16_t len, struct ip6_metadata *meta) {}

	event void LightSend.recvfrom(struct sockaddr_in6 *from, void *data, uint16_t len, struct ip6_metadata *meta) {
		single = FALSE;
	}

	event void Settings.recvfrom(struct sockaddr_in6 *from, void *data, uint16_t len, struct ip6_metadata *meta) {
		memcpy(&settings, data, sizeof(settings_t));
		call ConfigStorage.write(0, &settings, sizeof(settings));
	}

	//udp shell

	event char *GetCmd.eval(int argc, char **argv) {
		char *ret = call GetCmd.getBuffer(40);
		if (ret != NULL) {
			switch (argc) {
				case 1:
					sprintf(ret, "\t[Threshold: %u]\n\t[Instrument: %u]\n", settings.light_threshold, settings.instrument);
					break;
				case 2:
					if (!strcmp("th", argv[1])) {
						sprintf(ret, "\t[Threshold: %u]\n",settings.light_threshold);
					} else if (!strcmp("inst", argv[1])) {
						sprintf(ret, "\t[Instrument: %u]\n",settings.instrument);
					} else {
						strcpy(ret, "Usage: get [th | inst]\n");
					}
					break;
				default:
					strcpy(ret, "Usage: get [th | inst]\n");
			}
		}
		return ret;
	}

	task void report_settings() {
		call Settings.sendto(&multicast1, &settings, sizeof(settings));
		call ConfigStorage.write(0, &settings, sizeof(settings));
	}

	event char *SetCmd.eval(int argc, char **argv) {
		char *ret = call SetCmd.getBuffer(40);
		if (ret != NULL) {
			if (argc == 3) {
				if (!strcmp("th", argv[1])) {
					settings.light_threshold = atoi(argv[2]);
					sprintf(ret, ">>>Threshold changed to %u\n",settings.light_threshold);
				} else if (!strcmp("inst", argv[1])) {
					settings.instrument = atoi(argv[2]);
					sprintf(ret, ">>>Instrument changed to %u\n",settings.instrument);

				} else {
					strcpy(ret,"Usage: set [th | inst] [<threshold> | <instrument>]\n");
				}
			} else if (argc == 4) {
				if (!strcmp("th", argv[1]) && !strcmp("global", argv[3])) {
					settings.light_threshold = atoi(argv[2]);
					sprintf(ret, ">>>Threshold changed globally to %u\n",settings.light_threshold);
					post report_settings();
				} else {
					strcpy(ret,"Usage: set th <threshold> global\n");
				}
			} else {
				strcpy(ret,"Usage: set [th | inst] [<threshold> | <instrument>] [global]\n");
			}
		}
		return ret;
	}


	// Light sensor

	event void SensorReadTimer.fired() {
		call ReadPar.read();
	}

	task void report_light() {
		stats.seqno++;
		stats.sender = TOS_NODE_ID;
		stats.instrument = settings.instrument;
		call LightSend.sendto(&multicast2, &stats, sizeof(stats));
	}

	event void ReadPar.readDone(error_t e, uint16_t data) {
		if (e == SUCCESS) {
			m_par = data;
			single = TRUE;
			if (data > settings.light_threshold) {
				call Leds.set(7);
				post report_light();
				if (single) {
					call Publish.sendto(&route_dest, &stats, sizeof(stats));
				}
			} else {
				call Leds.set(0);
			}
		}
	}
}
