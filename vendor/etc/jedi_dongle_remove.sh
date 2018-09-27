#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`
echo "[EC_HID] JediDongleRemove, type $type" > /dev/kmsg

echo "[EC_HID][Remove] No Dongle" > /dev/kmsg

echo "[EC_HID][Remove] stop JediDongleSwitch" > /dev/kmsg
stop JediDongleSwitch

# Define rmmod function
function remove_mod(){

	if [ -n "$1" ]; then
		echo "[EC_HID] remove_mod $1" > /dev/kmsg
	else
		exit
	fi

	test=1
	while [ "$test" == 1 ]
	do
		rmmod $1
		ret=`lsmod | grep $1`
		if [ "$ret" == "" ]; then
			echo "[EC_HID] rmmod $1 success" > /dev/kmsg
			test=0
		else
			echo "[EC_HID] rmmod $1 fail" > /dev/kmsg
			test=1
			sleep 0.5
		fi
	done
}

# Remove all driver
echo 0 > /sys/bus/i2c/devices/2-0022/lightup
setprop sys.stn.regenfw 0
remove_mod jedi_station_touch
remove_mod nct7802
echo 0 > /proc/driver/tfa9894_fw_load
remove_mod ene_8k41_inbox
remove_mod ene_8k41_station
remove_mod ene_8k41_power
remove_mod ene_8k41_pogo
remove_mod station_key

# Enable Phone aura
echo 1 > /sys/class/leds/aura_sync/VDD
sleep 0.5

phone_aura=`cat /sys/class/leds/aura_sync/fw_ver`
setprop sys.phone.aura_fwver $phone_aura

# do not add any action behind here
setprop sys.aura.donglechmod 0

# force reset accy FW
setprop sys.inbox.aura_fwver 0
setprop sys.station.ec_fwver 0
setprop sys.station.aura_fwver 0
setprop sys.station.tp_fwver 0
setprop sys.station.dp_fwver 0
setprop sys.dt.aura_fwver 0
setprop sys.dt.power_fwver 0
setprop sys.station.pd_fwver 0
setprop sys.dt.pd_fwver 0
setprop sys.dt.hub1_fwupdate 0
setprop sys.dt.hub2_fwupdate 0
setprop sys.asus.accy.fw_status 000000
setprop sys.asus.accy.fw_status2 000000

# Send uevent to FrameWork
echo 0 > /sys/class/ec_hid/dongle/device/sync_state
