#!/system/bin/sh
#Make sure Bluetooth of UI is disable
TAG="btoff"
SAVE_PATH=/data/media/0/
dumpsys bluetooth_manager > $SAVE_PATH/bt_status.txt

setprop debug.bluetooth.isEnabled `cat $SAVE_PATH/bt_status.txt|grep "state:" | sed 's/^.*: //g'`
bt_status=`getprop debug.bluetooth.isEnabled`
log -t "$TAG" "debug.bluetooth.isEnabled $bt_status"

if [ "${bt_status}" = "ON" ]; then
    log -t "$TAG" "turn off bt"
    service call bluetooth_manager 8 > /dev/null 2> /dev/null
    sleep 1
    dumpsys bluetooth_manager > $SAVE_PATH/bt_status.txt
    bt_status=`cat $SAVE_PATH/bt_status.txt|grep "state:" | sed 's/^.*: //g'`
    setprop debug.bluetooth.isEnabled `cat $SAVE_PATH/bt_status.txt|grep "state:" | sed 's/^.*: //g'`
fi


exit 0
