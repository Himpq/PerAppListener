
MODDIR=${0%/*}

UPERF="/storage/emulated/0/Android/yc/uperf/cur_powermode.txt"
UPERFSET="/storage/emulated/0/Android/yc/uperf/perapp_powermode.txt"
LOG="/storage/emulated/0/Android/perapp/log.txt"

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

inotifywait -m /dev/cpuset/top-app | while read x1 x2 x3; do
    topApps=$(getTopApps)
    topApp=$(echo "$topApps" | awk 'NR==1')

    defaultMode=$(grep '^*' $UPERFSET | awk -F ' ' '{print $2}')
    appMode=$(getAppMode "$topApp")

    changeTo=$([ "$appMode" == "" ] && echo "$defaultMode" || echo "$appMode")

    if [ "$prevTopApps" != "$topApps" ] && [ "$topApps" != "" ] ; then

        nowStat=$(cat "$UPERF")
        if [ "$changeTo" != "$nowStat" ]; then
            p_log "$topApp -> $changeTo"
            echo "$changeTo" > "$UPERF"

            prevTopApps="$topApps"
        fi

        prevTopApps="$topApps"
    fi
done
