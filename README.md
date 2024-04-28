# PerAppListener
A Magisk module for uperf(A13)

## 原理
使用 getevent -l 监听 **/dev/input/event1** 下的电源键点击事件，并借助 **dumpsys** 判断是否为亮屏或息屏状态，并写入切换的状态到 **/storage/emulated/0/Android/yc/uperf/cur_powermode.txt**内。  
使用 inotifywait 监听 **/dev/cpuset/top-app** 的文件变动，并借助 **dumpsys** 判断顶层应用，并将应用调度写入到上文uperf的调度配置文件中。
