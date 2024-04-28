#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future

UPERF="/storage/emulated/0/Android/yc/uperf/cur_powermode.txt"
UPERFSET="/storage/emulated/0/Android/yc/uperf/perapp_powermode.txt"
LOG="/storage/emulated/0/Android/perapp/log.txt"

p_log () {
    echo "[$(date +'%H:%M:%S')] $1" >> "$LOG"
}

while true; do
    if [ "$(getprop sys.boot_completed)" == "1" ]; then
        break
    fi
    sleep 5
done

sleep 30

MODDIR=${0%/*}

mkdir /storage/emulated/0/Android/perapp/

p_log "Starting modules..."


chmod a+x "$MODDIR/*.sh"
chmod 777 -R "$MODDIR"

killProcess () {
    ps -ef | grep "$MODDIR/ScreenStatCheck.sh" | awk '{print $2}'| while read pid;
        do
            kill -9 $pid >/dev/null 2>&1
        done

    ps -ef | grep "$MODDIR/TopAppCheck.sh" |awk '{print $2}'| while read pid;
        do
            kill -9 $pid >/dev/null 2>&1
        done
}

killProcess

echo "Starting PerAppListener..." > "$LOG"

nohup "$MODDIR/common/ScreenStatCheck.sh" > /dev/null 2>&1 &
nohup "$MODDIR/common/TopAppCheck.sh" > /dev/null 2>&1 &
