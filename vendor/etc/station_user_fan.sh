#!/vendor/bin/sh

dongle_type=`getprop sys.asus.dongletype`
fan_type=`getprop persist.asus.userfan`
micfansettings_type=`getprop persist.asus.micfansettings`
mic_type=`getprop sys.asus.fan.mic`


if [ "$dongle_type" == "2" ]; then
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo c 0 > /sys/class/ec_hid/dongle/device/set_gpio
		echo "[STATION_FAN][USER]enable_mic" > /dev/kmsg
	else
		if [ "$fan_type" == "0" ]; then
			echo c 0 > /sys/class/ec_hid/dongle/device/set_gpio
		elif [ "$fan_type" == "1" ]; then
			echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
			echo c > /sys/class/ec_hid/dongle/device/get_gpio
			echo 0 0 > /sys/class/ec_hid/dongle/device/freq
			echo ff 7f > /sys/class/ec_hid/dongle/device/duty
			echo 1 > /sys/class/ec_hid/dongle/device/pwm
		elif [ "$fan_type" == "2" ]; then
			echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
			echo c > /sys/class/ec_hid/dongle/device/get_gpio
			echo 0 0 > /sys/class/ec_hid/dongle/device/freq
			echo ff 65 > /sys/class/ec_hid/dongle/device/duty
			echo 1 > /sys/class/ec_hid/dongle/device/pwm
		elif [ "$fan_type" == "3" ]; then
			echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
			echo c > /sys/class/ec_hid/dongle/device/get_gpio
			echo 0 0 > /sys/class/ec_hid/dongle/device/freq
			echo ff 4b > /sys/class/ec_hid/dongle/device/duty
			echo 1 > /sys/class/ec_hid/dongle/device/pwm
		elif [ "$fan_type" == "4" ]; then
			echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
			echo c > /sys/class/ec_hid/dongle/device/get_gpio
			echo 0 0 > /sys/class/ec_hid/dongle/device/freq
			echo ff c5 > /sys/class/ec_hid/dongle/device/duty
			echo 1 > /sys/class/ec_hid/dongle/device/pwm
		elif [ "$fan_type" == "auto" ]; then
			setprop persist.asus.tempfan 1
		fi
	fi
fi
