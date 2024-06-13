#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future

# Wait for boot
while true; do
    if [ "$(getprop sys.boot_completed)" == "1" ]; then
        break
    fi
    sleep 5
done

wait_until_login() {
    # we doesn't have the permission to rw "/sdcard" before the user unlocks the screen
    local test_file="/sdcard/Android/.PERMISSION_TEST"
    true >"$test_file"
    while [ ! -f "$test_file" ]; do
        true >"$test_file"
        sleep 1
    done
    rm "$test_file"
}


wait_until_login
# Start services

# Define some paths
MODDIR=${0%/*}
STORAGE="/storage/emulated/0"
LOG="$STORAGE/Android/perapp/log.txt"

CurPath="$STORAGE/Android/perapp/uperf_cur_path.txt"
ModePath="$STORAGE/Android/perapp/uperf_mode_path.txt"
EventPath="$STORAGE/Android/perapp/power_event_path.txt"
AutoCheck="$STORAGE/Android/perapp/auto_check.txt"

# Default Uperf Path Settings
UPERF="/storage/emulated/0/Android/yc/uperf/cur_powermode.txt"
UPERFSET="/storage/emulated/0/Android/yc/uperf/perapp_powermode.txt"


# Change permissions
chmod 777 -R "$MODDIR"
chmod 777 -R "$MODDIR/common"

# Check uperf settings
if [ ! -d "$STORAGE/Android/perapp" ] || [ ! -f "$CurPath" ] || [ ! -f "$ModePath" ] || [ ! -f "$EventPath" ] || [ ! -f "$AutoCheck" ]; then
    mkdir $STORAGE/Android/perapp/
    
    echo "$UPERF" > "$CurPath"
    echo "$UPERFSET" > "$ModePath"
    echo "/dev/input/event1" > "$EventPath"
    echo "15" > "$AutoCheck"
else
    UPERF=$(cat "$CurPath")
    UPERFSET=$(cat "$ModePath")
fi

# Kill all processes to avoid running module repeatedly
sh ./common/killAllPerAppLsnProcesses.sh
sleep 1
# Clean Log
echo "" > "$LOG" 

echo "Uperf Cur Path: $UPERF"     >> "$LOG"
echo "Uperf Mod Path: $UPERFSET"  >> "$LOG"
echo "Starting PerAppListener..."

nohup "$MODDIR/common/ScreenStatCheck.sh" > /dev/null 2>&1 &
nohup "$MODDIR/common/TopAppCheck.sh" > /dev/null 2>&1 &

echo "Loaded." >> "$LOG"
