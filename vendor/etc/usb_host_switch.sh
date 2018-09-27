#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`
LOG_TAG="usb_host_switch"

echo 1 > /sys/module/dwc3_msm/parameters/setModefromPOGO
if [ "$type" == "0" ]; then
	echo "$LOG_TAG:[USB] No Dongle. usb1 none(by charger id notify), usb2 none" > /dev/kmsg
	echo none > /sys/devices/platform/soc/a800000.ssusb/mode
	echo 11 > /sys/bus/i2c/devices/0-004e/tcpc/type_c_port0/pd_test
	sleep 1
	echo 10 > /sys/bus/i2c/devices/0-004e/tcpc/type_c_port0/pd_test
elif [ "$type" == "1" ]; then
	echo "$LOG_TAG:[USB] InBox. usb2 host" > /dev/kmsg
	echo host > /sys/devices/platform/soc/a800000.ssusb/mode
	echo 12 > /sys/bus/i2c/devices/0-004e/tcpc/type_c_port0/pd_test
elif [ "$type" == "2" ]; then
	echo "$LOG_TAG:[USB] Station. usb1 host(by charger id notify), usb2 none" > /dev/kmsg
	echo none > /sys/devices/platform/soc/a800000.ssusb/mode
elif [ "$type" == "3" ]; then
	echo "$LOG_TAG:[USB] DT. usb2 host" > /dev/kmsg
	echo host > /sys/devices/platform/soc/a800000.ssusb/mode
	echo 12 > /sys/bus/i2c/devices/0-004e/tcpc/type_c_port0/pd_test
else
	echo "$LOG_TAG:[USB] dongle type ERROR. type=$type. no action." > /dev/kmsg
fi
echo 0 > /sys/module/dwc3_msm/parameters/setModefromPOGO
