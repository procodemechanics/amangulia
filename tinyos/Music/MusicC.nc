#include "StorageVolumes.h"

configuration MusicC {

} implementation {
	components MainC, LedsC, MusicP;
	MusicP.Boot -> MainC;
	MusicP.Leds -> LedsC;

	components IPStackC;
	components RPLRoutingC;
	components StaticIPAddressTosIdC;
	MusicP.RadioControl -> IPStackC;

	components UdpC;
	components new UdpSocketC() as VoltSend;
	MusicP.VoltSend -> VoltSend;
	components new UdpSocketC() as Settings;
	MusicP.Settings -> Settings;

	components UDPShellC;
	components new ShellCommandC("get") as GetCmd;
	components new ShellCommandC("set") as SetCmd;
	MusicP.GetCmd -> GetCmd;
	MusicP.SetCmd -> SetCmd;

	components new VoltageC();
	MusicP.Volt -> VoltageC.Read;

	components new TimerMilliC() as VoltTimer;
	MusicP.VoltTimer -> VoltTimer;

	components new ConfigStorageC(VOLUME_CONFIG) as VoltSettings;
	MusicP.ConfigMount -> VoltSettings;
	MusicP.ConfigStorage -> VoltSettings;
}
