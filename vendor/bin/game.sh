#!/vendor/bin/sh


is_gaming=`getprop sys.asus.gamingtype`

if [ "$is_gaming" == "1" ]; then
	echo "performance" > /sys/class/devfreq/soc:qcom,cpubw/governor

elif [ "$is_gaming" == "0" ]; then
	echo "bw_hwmon" > /sys/class/devfreq/soc:qcom,cpubw/governor

fi
