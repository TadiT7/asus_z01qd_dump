#!/system/bin/sh

export PATH=/system/bin
THERMAL_DUMPSYS=`getprop sys.thermal.dumpsys`
if [ "$THERMAL_DUMPSYS" == "1" ]; then
    dumpsys sensorservice | grep -A50 'active connection' >> /data/logcat_log/logcat.txt
    /vendor/bin/sns_dump_pm
    setprop sys.thermal.dumpsys 0
fi

Grip_Check(){
	RESULT="PASS"
	setprop persist.grip.error_code 0
	sleep 5
	echo "*** START:$GRIP_CAL ***" >> /data/misc/grip/parse_result
	STR1=`cat /data/misc/grip/snt_result | cut -d " " -f 1`
	STR1=`echo $STR1|cut -d " " -f 1`
	echo "====part1====" >> /data/misc/grip/parse_result
	echo $STR1 >> /data/misc/grip/parse_result
	if [ "$STR1" == "FAILED" ]; then
		STR2=`cat /data/misc/grip/snt_result | cut -d " " -f 2`
		STR2=`echo $STR2| cut -d " " -f 1`
		echo "====part2====" >> /data/misc/grip/parse_result
		echo $STR2 >> /data/misc/grip/parse_result
		setprop persist.grip.error_code $STR2
	elif [ "$STR1" == "PASS" ]; then
		echo "====part3====" >> /data/misc/grip/parse_result
		echo $RESULT >> /data/misc/grip/parse_result
		setprop persist.grip.error_code $RESULT
	else
		echo "====part4====" >> /data/misc/grip/parse_result
		echo "STR1=$STR1 No condition meet" >> /data/misc/grip/parse_result
		setprop persist.grip.error_code $RESULT
	fi
	echo "*** END ***" >> /data/misc/grip/parse_result
}
GRIP_CAL=`getprop persist.grip.calibration`

if [ "$GRIP_CAL" == "0" ]; then
	exit
fi

if [ "$GRIP_CAL" == "1" ]; then
	setprop persist.grip.calibration_done 0
	echo 1 > /sys/snt8100fsr/chip_reset
	sleep 5
	/vendor/bin/SNTMfgUtil -r
	sleep 1
	rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar1
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "2" ]; then
	setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -r
    sleep 1
    echo 1 > /sys/snt8100fsr/chip_reset
    sleep 5
	rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar2
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "3" ]; then
	setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -r
    sleep 1
    echo 1 > /sys/snt8100fsr/chip_reset
    sleep 5
	rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar3
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "4" ]; then
	setprop persist.grip.calibration_done 0
	rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -i
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "5" ]; then
	setprop persist.grip.calibration_done 0
	rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -c pzt
    Grip_Check
    setprop persist.grip.calibration_done 1
    cat /vendor/factory/snt_reg_init > /sys/snt8100fsr/boot_init_reg
fi
if [ "$GRIP_CAL" == "6" ]; then
	setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -r
    sleep 1
	rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -g
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "7" ]; then
    setprop persist.grip.calibration_done 0
    echo 1 > /sys/snt8100fsr/chip_reset
    sleep 5
    /vendor/bin/SNTMfgUtil -r
    sleep 1
	rm /data/misc/grip/snt_result
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar1 bar2 bar3
    Grip_Check
    setprop persist.grip.calibration_done 1
fi
