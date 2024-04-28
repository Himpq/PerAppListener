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
sleep 30


# Start services

# Define some paths
MODDIR=${0%/*}
STORAGE="/storage/emulated/0"
LOG="$STORAGE/Android/perapp/log.txt"
CurPath="$STORAGE/Android/perapp/uperf_cur_path.txt"
ModePath="$STORAGE/Android/perapp/uperf_mode_path.txt"

# Default Uperf Path Settings

UPERF="/storage/emulated/0/Android/yc/uperf/cur_powermode.txt"
UPERFSET="/storage/emulated/0/Android/yc/uperf/perapp_powermode.txt"
# Change permissions
chmod 777 -R "$MODDIR"
chmod 777 -R "$MODDIR/common"

# Check uperf settings
if [ ! -d "$STORAGE/Android/perapp" ] || [ ! -f "$CurPath" ] || [ ! -f "$ModePath" ]; then
    mkdir $STORAGE/Android/perapp/
    
    echo "$UPERF" > "$CurPath"
    echo "$UPERFSET" > "$ModePath"
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
