#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`
hubdetect=`getprop sys.dt.hubdetect`
LOG_TAG="DT_hub_Detect"
hub1_version=''
hub2_version=''
HUB1_FW_VER=`getprop sys.asusfw.dt.hub1_fwver`
HUB2_FW_VER=`getprop sys.asusfw.dt.hub2_fwver`

if [ "$type" == "3" ]; then
	echo "$LOG_TAG:[USB_ACCY] DT hub detected = $hubdetect" > /dev/kmsg
	if [ "$hubdetect" == "0" ];then
		echo "$LOG_TAG:[USB_ACCY] reset hub1_fwver/hub2_fwver" > /dev/kmsg
		setprop sys.dt.hub1_fwver ''
		setprop sys.dt.hub2_fwver ''
	elif [ "$hubdetect" == "1" ];then
		sleep 3
		type=`getprop sys.asus.dongletype`
		if [ "$type" == "3" ]; then
			lsusb | grep 05e3:0610 > /sdcard/gl_usb_list
			hub1_version=`/system/bin/DTHubFwUpdater version |grep "\[0\]" | cut -d ":" -f 2`
			if [ "$hub1_version" == "ffff" ];then
				hub1_version='0'
			fi
			echo "$LOG_TAG:[USB_ACCY] DT hub1 version = $hub1_version" > /dev/kmsg
			setprop sys.dt.hub1_fwver $hub1_version
			hub2_version=`/system/bin/DTHubFwUpdater version |grep "\[1\]" | cut -d ":" -f 2`
			if [ "$hub2_version" == "ffff" ];then
				hub2_version='0'
			fi
			echo "$LOG_TAG:[USB_ACCY] DT hub2 version = $hub2_version" > /dev/kmsg
			setprop sys.dt.hub2_fwver $hub2_version
			rm /sdcard/gl_usb_list

			/system/bin/update_accy_status2.sh
		else
			echo "$LOG_TAG:[USB_ACCY] DT is disconnect, ignore" > /dev/kmsg
			setprop sys.dt.hub1_fwver ''
			setprop sys.dt.hub2_fwver ''
		fi
	fi
else
	echo "$LOG_TAG:[USB_ACCY] not connect DT" > /dev/kmsg
	setprop sys.dt.hub1_fwver ''
	setprop sys.dt.hub2_fwver ''
fi


