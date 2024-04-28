#!/system/bin/sh

MODDIR=${0%/*}

STORAGE="/storage/emulated/0"


LOG="$STORAGE/Android/perapp/log.txt"
CurPath="$STORAGE/Android/perapp/uperf_cur_path.txt"
ModePath="$STORAGE/Android/perapp/uperf_mode_path.txt"

# Default settings
UPERF=$(cat "$CurPath")
UPERFSET=$(cat "$ModePath")
p_log () {
    echo "[$(date +'%H:%M:%S')] $1" >> "$LOG"
}


changemod () {
    tomode="$1"
    echo "$tomode" > "$UPERF"
}

checkscreen () {
    sleep 0.5

    isScreenOn=$(dumpsys deviceidle | grep mScreenOn | sed 's/^[ \t]*//g' | sed 's/[ \t]*$//g' | awk -F '=' '{print $2}')
    offscreenMode=$(grep '^-' $UPERFSET | awk -F ' ' '{print $2}')
    screenonMode=$(grep '^*' $UPERFSET | awk -F ' ' '{print $2}')
    changeTo=$([ "$isScreenOn" == "true" ] && echo "$screenonMode" || echo "$offscreenMode")

    nowStat=$(cat "$UPERF")
    if [ "$changeTo" != "$nowStat" ]; then
        echo "Success into: $isScreenOn -> $changeTo"
        p_log "isScreenOn=$isScreenOn -> $changeTo"

        changemod "$changeTo"
    fi
}

fingerprintUnlock () {
    
    offscreenMode=$(grep '^-' $UPERFSET | awk -F ' ' '{print $2}')
    screenonMode=$(grep '^*' $UPERFSET | awk -F ' ' '{print $2}')

    if [ "$1" == "DOWN" ]; then
        nowStat=$(cat "$UPERF")
        if [ "$screeononMode" == "$nowStat" ]; then
            return
        fi
        changemod "$screeononMode"

        p_log "FP Touching -> $screenonMode"

    else

        sleep 0.5
        isScreenOn=$(dumpsys deviceidle | grep mScreenOn | sed 's/^[ \t]*//g' | sed 's/[ \t]*$//g' | awk -F '=' '{print $2}')
        nowStat=$(cat "$UPERF")


        if [ "$isScreenOn" == "true" ]; then

            p_log "FP SUC -> $screenonMode"

            if [ "$screeononMode" == "$nowStat" ]; then
                return
            fi
            changemod "$screeononMode"

        else

            p_log "FP FAIL -> $offscreenMode"

            if [ "$offscreenMode" == "$nowStat" ]; then
                return
            fi
            changemod "$offscreenMode"
            
        fi
    fi
}

p_log "Starting ScreenStatCheck..."

getevent -l /dev/input/event1 | grep "SYN_REPORT" | while read event key typ; do 
    checkscreen
done &

getevent -l /dev/input/event5 | grep "0152" | while read xp1 xp2 xp3; do
    fingerprintUnlock "$xp3"
done
