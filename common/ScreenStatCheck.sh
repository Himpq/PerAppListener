#!/system/bin/sh

MODDIR=${0%/*}

STORAGE="/storage/emulated/0"

# 1Unit = 0.01s
# 100Unit = 1s

FINGERPOINT_DELAY_OFFSET=100  


LOG="$STORAGE/Android/perapp/log.txt"
CurPath="$STORAGE/Android/perapp/uperf_cur_path.txt"
ModePath="$STORAGE/Android/perapp/uperf_mode_path.txt"

# Default settings
UPERF=$(cat "$CurPath")
UPERFSET=$(cat "$ModePath")

p_log () {
    echo "[$(date +'%H:%M:%S')] $1" >> "$LOG"
}

# changemod "MODE" "LOG"
changemod () {
    toMode="$1"
    nowMode=$(cat "$UPERF")
    if [ "$nowMode" != "$toMode" ]; then
        echo "$toMode" > "$UPERF"
        p_log "$2"
    fi
}

checkscreen () {
    sleep 0.5

    isScreenOn=$(dumpsys deviceidle | grep mScreenOn | sed 's/^[ \t]*//g' | sed 's/[ \t]*$//g' | awk -F '=' '{print $2}')
    offscreenMode=$(grep '^-' $UPERFSET | awk -F ' ' '{print $2}')
    screenonMode=$(grep '^*' $UPERFSET | awk -F ' ' '{print $2}')
    changeTo=$([ "$isScreenOn" == "true" ] && echo "$screenonMode" || echo "$offscreenMode")

    changemod "$changeTo" "isScreenOn=$isScreenOn -> $changeTo"
}

getScreenStat () {
    echo "$(dumpsys deviceidle | grep mScreenOn | sed 's/^[ \t]*//g' | sed 's/[ \t]*$//g' | awk -F '=' '{print $2}')"
}

fingerprintUnlock () {
    
    offscreenMode=$(grep '^-' $UPERFSET | awk -F ' ' '{print $2}')
    screenonMode=$(grep '^*' $UPERFSET | awk -F ' ' '{print $2}')

    if [ "$1" == "DOWN" ]; then
        changemod "$screenonMode" "FP Touching -> $screenonMode"
    else
        i=0
        while (( $i < $FINGERPOINT_DELAY_OFFSET )); do

            isScreenOn="$(getScreenStat)"

            if [ "$isScreenOn" == "true" ]; then
                changemod "$screenonMode" "FP SUC -> $screenonMode"
                return
            fi

            i=$((i+1))
            sleep 0.01
        done

        changemod "$offscreenMode" "FP FAIL -> $offscreenMode"
    fi
}

p_log "Starting ScreenStatCheck..."

getevent -l /dev/input/event1 | grep "SYN_REPORT" | while read event key typ; do 
    checkscreen
done &

getevent -l /dev/input/event5 | grep "0152" | while read xp1 xp2 xp3; do
    fingerprintUnlock "$xp3"
done
