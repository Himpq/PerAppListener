MODDIR=${0%/*}

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
echo Killing processes...

killProcess

echo Processes were killed.
