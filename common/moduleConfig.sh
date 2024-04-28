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
