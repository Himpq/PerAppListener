
MODDIR=${0%/*}

nohup "$MODDIR/common/ScreenStatCheck.sh" > /dev/null 2>&1 &
nohup "$MODDIR/common/TopAppCheck.sh" > /dev/null 2>&1 &
#$MODDIR/common/ScreejnStatCheck.sh &
#$MODDIR/common/TopAppCheck.sh
