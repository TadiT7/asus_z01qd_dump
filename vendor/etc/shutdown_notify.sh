#!/vendor/bin/sh

echo 0 > /sys/class/leds/aura_sync_station/VDD
echo c 0 > /sys/class/ec_hid/dongle/device/set_gpio
echo 1 > /sys/class/ec_hid/dongle/device/shutdown
