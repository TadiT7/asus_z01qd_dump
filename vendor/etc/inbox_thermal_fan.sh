#!/vendor/bin/sh

dongle_type=`getprop sys.asus.dongletype`
fan_type=`getprop persist.asus.userfan`
thermal_type=`getprop persist.asus.thermalfan`
micfansettings_type=`getprop persist.asus.micfansettings`
mic_type=`getprop sys.asus.fan.mic`


if [ "$dongle_type" == "1" ]; then
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo 0 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
		cat /sys/class/hwmon/Inbox_Fan/device/PWM
		echo "[INBOX_FAN][AUTO]enable_mic" > /dev/kmsg
	else
		if [ "$fan_type" == "auto" ]; then
			echo "thermal fan"
			if [ "$thermal_type" == "0" ]; then
				echo 3 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
			elif [ "$thermal_type" == "1" ]; then
				echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
			elif [ "$thermal_type" == "2" ]; then
				echo 2 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
			elif [ "$thermal_type" == "3" ]; then
				echo 3 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
			elif [ "$thermal_type" == "4" ]; then
				echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
			fi
		else
				echo "thermal fan isn't auto"
		fi
	fi
fi
