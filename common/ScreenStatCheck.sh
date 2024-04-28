#!/system/bin/sh

MODDIR=${0%/*}

UPERF="/storage/emulated/0/Android/yc/uperf/cur_powermode.txt"
UPERFSET="/storage/emulated/0/Android/yc/uperf/perapp_powermode.txt"
LOG="/storage/emulated/0/Android/perapp/log.txt"

p_log () {
    echo "[$(date +'%H:%M:%S')] $1" >> "$LOG"
}

changemod () {
    tomode="$1"
    echo "$tomode" > "$UPERF"
    p_log "isScreenOn=$isScreenOn -> $tomode"
}

checkscreen () {
    sleep 0.5

    isScreenOn=$(dumpsys deviceidle | grep mScreenOn | sed 's/^[ \t]*//g' | sed 's/[ \t]*$//g' | awk -F '=' '{print $2}')
    offscreenMode=$(grep '^-' $UPERFSET | awk -F ' ' '{print $2}')
    screenonMode=$(grep '^*' $UPERFSET | awk -F ' ' '{print $2}')
    changeTo=$([ "$isScreenOn" == "true" ] && echo "$screenonMode" || echo "$offscreenMode")

    echo "Success into: $isScreenOn -> $changeTo"
    changemod "$changeTo"
}

p_log "Starting ScreenStatCheck..."

getevent -l /dev/input/event1 | while read event key typ; do 
    checkscreen
done
