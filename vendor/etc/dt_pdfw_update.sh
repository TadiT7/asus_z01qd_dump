#!/vendor/bin/sh

type=`getprop sys.dt.pd_fwupdate`
updateon=`getprop sys.dt.updatepdon`

if [ "$type" == "0" ]; then
	echo "[PD_DT] No need update PD FW" > /dev/kmsg
	exit
elif [ "$type" == "1" ]; then
	FW_PATH="/vendor/asusfw/DT_pd_fw/DT_DOCK_PD.bin"
fi

if [ "$updateon" != "1" ]; then
	echo "[PD_DT] PD update trun off" > /dev/kmsg
	setprop sys.dt.pd_fwupdate  0
	exit
fi

echo "[PD_DT] Start PD FW update : $FW_PATH" > /dev/kmsg

echo 1 > /sys/class/leds/DT_power/pd_switch
echo 1 > /sys/class/leds/DT_power/pause
echo 1 > /sys/fs/selinux/ec

/vendor/bin/DTUSBPDFwUpdater -f /vendor/asusfw/DT_pd_fw/DT_DOCK_PD.bin

echo 0 > /sys/fs/selinux/ec
echo 0 > /sys/class/leds/DT_power/pause
echo 0 > /sys/class/leds/DT_power/pd_switch

echo "[PD_DT] Finish EC FW update" > /dev/kmsg

sleep 4
pd_fw=`getprop sys.asusfw.dt.pd_fwver`
fw_ver=`cat /sys/class/usbpd/usbpd0/pdfw`
if [ "${fw_ver}" != "${pd_fw}" ]; then
	echo "[PD_DT] PD FW update fail pd:$pd_fw fw:$fw_ver" > /dev/kmsg
	setprop sys.dt.pd_fwupdate  2

else
	echo "[PD_DT] PD FW update OK pd:$pd_fw fw:$fw_ver" > /dev/kmsg
	setprop sys.dt.pd_fwupdate  0
fi
