#!/vendor/bin/sh

type=`getprop sys.station.fwupdate`

if [ "$type" == "0" ]; then
	echo "[EC_HID] No need update EC FW" > /dev/kmsg
	exit
elif [ "$type" == "2" ]; then
	# No PX
	FW_PATH="/vendor/asusfw/station/dock_V030.bin"
elif [ "$type" == "1" ]; then
	# PX
	FW_PATH="/vendor/asusfw/station/IT8913.bin"
fi

echo "[EC_HID] Start EC FW update : $FW_PATH" > /dev/kmsg
echo 1 > /sys/fs/selinux/ec
echo 1 > /sys/class/ec_hid/dongle/device/lock

/vendor/bin/ec_update /vendor/asusfw/station/IT8913.bin > /data/local/tmp/ec_update.log

echo 0 > /sys/class/ec_hid/dongle/device/lock
echo 0 > /sys/fs/selinux/ec

# wait HID reconnect
sleep 5

echo "[EC_HID] Finish EC FW update" > /dev/kmsg

ec_fw=`getprop sys.asusfw.station.ec_fwver`
fw_ver=`cat /sys/class/ec_hid/dongle/device/fw_ver`
if [ "${fw_ver}" != "${ec_fw}" ]; then
	echo "[EC_HID] EC FW update fail" > /dev/kmsg
	setprop sys.station.fwupdate  2

else
	setprop sys.station.fwupdate  0
fi

#echo "[EC_HID] Wait HID connect" > /dev/kmsg
#sleep 2

#start DongleFWCheck
setprop sys.asus.accy.fw_status 000000
