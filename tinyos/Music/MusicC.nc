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
	components new UdpSocketC() as LightSend;
	MusicP.LightSend -> LightSend;
	components new UdpSocketC() as Settings;
	MusicP.Settings -> Settings;

	components UDPShellC;
	components new ShellCommandC("get") as GetCmd;
	components new ShellCommandC("set") as SetCmd;
	MusicP.GetCmd -> GetCmd;
	MusicP.SetCmd -> SetCmd;

	components new TimerMilliC() as SensorReadTimer;
	MusicP.SensorReadTimer -> SensorReadTimer;

	components new ConfigStorageC(VOLUME_CONFIG) as LightSettings;
	MusicP.ConfigMount -> LightSettings;
	MusicP.ConfigStorage -> LightSettings;

	components new HamamatsuS1087ParC() as SensorPar;
	MusicP.ReadPar -> SensorPar.Read;
}
