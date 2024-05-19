
MODDIR=${0%/*}

STORAGE="/storage/emulated/0"
INOTIFYWAIT_PATH="$MODDIR/../system/xbin/inotifywait"

LOG="$STORAGE/Android/perapp/log.txt"
CurPath="$STORAGE/Android/perapp/uperf_cur_path.txt"
ModePath="$STORAGE/Android/perapp/uperf_mode_path.txt"

# Default settings
UPERF=$(cat "$CurPath")
UPERFSET=$(cat "$ModePath")


p_log () {
    echo "[$(date +'%H:%M:%S')] $1" >> "$LOG"
}

getTopApps () {
    echo "$(dumpsys activity activities | grep "VisibleActivityProcess" | grep -oE '[a-zA-Z0-9.]+/[a-zA-Z0-9.]+' | awk -F '/' '{print $1}')" 
}

# getAppMode "appname"
getAppMode () {
    mode=$(grep "$1" "$UPERFSET" | awk '{print $2}')
    echo "$mode"
}

prevTopApps=""

p_log "Starting TopAppCheck..."

$INOTIFYWAIT_PATH -m /dev/cpuset/top-app | while read x1 x2 x3; do
    # get top apps
    topApps=$(getTopApps)
    topApp=$(echo "$topApps" | awk 'NR==1')

    # get mode from uperf
    defaultMode=$(grep '^*' $UPERFSET | awk -F ' ' '{print $2}')
    appMode=$(getAppMode "$topApp")
    changeTo=$([ "$appMode" == "" ] && echo "$defaultMode" || echo "$appMode")

    if [ "$prevTopApps" != "$topApps" ] && [ "$topApps" != "" ] ; then

        # check the status to avoid writing it repeatedly
        nowStat=$(cat "$UPERF")
        if [ "$changeTo" != "$nowStat" ]; then
            p_log "$topApp -> $changeTo"
            echo "$changeTo" > "$UPERF"
        fi

        prevTopApps="$topApps"
    fi
done
