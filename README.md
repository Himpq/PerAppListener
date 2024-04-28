# PerAppListener
A Magisk module for uperf(A13)

## 原理
使用 getevent -l 监听 **/dev/input/event1** 下的电源键点击事件，并借助 **dumpsys** 判断是否为亮屏或息屏状态，并写入切换的状态到 **/storage/emulated/0/Android/yc/uperf/cur_powermode.txt**内。  
  
使用 inotifywait 监听 **/dev/cpuset/top-app** 的文件变动，并借助 **dumpsys** 判断顶层应用，并将应用调度写入到上文uperf的调度配置文件中。  

## 使用
* 安装 Uperf v3 (22.09.04) ，然后安装本模块。
* 检查 内部存储/Android/perapp/log.txt 是否存在且正常。
* 根据自身需求更改 uperf 各应用调度的配置，如启动**原神**（原神是 Uperf 默认应用调度中的示例，为**fast**），再检查日志是否正常。
* 尝试息屏 2~3 秒打开，检查日志，查看是否正确处理了息屏状态。
* 恭喜，本模块在您的手机上运行正常！如果产生了错误，请于 Github 反馈 Issue 或联系邮箱 himpq@qq.com。

## 注意
* 若您的手机版本与上述文本中的测试机型不同，请不要安装 v2.0.0 的 release。
* 若您有意无偿提供测试信息，且有一定 **adb** 基础，请与我联系适配。

## 更新日志
* v2.0.0：
*   监听 HyperOS 锁屏触控 **/dev/input/event5** 的 **0152** （因手上没有其他机子尚不清楚该事件是否是通用指纹解锁按钮事件），使得指纹解锁可以正常触发亮屏调度。
* v1.0.0:
*   OUT!!!!!!!!!!!!
