#!/vendor/bin/sh

#prop_type=`getprop sys.asus.dongletype`
LOG_TAG="EC_HID"
gDongleType=`cat /sys/class/ec_hid/dongle/device/gDongleType`

#if [ "$gDongleType" == "0" ]; then
#	echo "Do not trigger uevent"
#	exit
#fi

echo "[$LOG_TAG] re-send dongle type uevent " > /dev/kmsg
echo $gDongleType > /sys/class/ec_hid/dongle/device/gDongleType
