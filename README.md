# PerAppListener
一个 **接管** Uperf 调度切换的模块。（会与 Scene 等调度切换软件、模块冲突）  

## 原理
* 监听系统前台切换事件与电源键、锁屏解锁事件，以达到原 Uperf 自动切换应用调度的功能。
* 不会与其他调度配置文件冲突，因为本模块会实时读取 Uperf 的各应用调度。
  


## 使用
* 安装 Uperf v3 (22.09.04) ，然后安装本模块。
* 检查 内部存储/Android/perapp/log.txt 是否存在且正常。
* 检查 内部存储/Android/perapp/ 下的 **uperf_cur_path.txt** 和 **uperf_mode_path.txt** 是否分别对应着你手机内的 Uperf 的 配置切换文件与各应用调度文件。
* 根据自身需求更改 Uperf 各应用调度的配置，如启动**原神**（原神是 Uperf 默认应用调度中的示例，为**fast**），再检查日志是否正常。
* 尝试息屏 2~3 秒打开，检查日志，查看是否正确处理了息屏状态。
* 恭喜，本模块在您的手机上运行正常！如果产生了错误，请于 Github 反馈 Issue 或联系邮箱 himpq@qq.com。

## 适配机型操作
* 你需要在终端依次执行**getevent -l /dev/input/event(N)** (请将N更改为你在/dev/input文件夹下看到的文件末尾数字）。
  
* 如event1, event2, event3 ... 就依次执行对应的代码，在每个代码执行中请息屏并尝试使用指纹解锁，如果有输出反应，请记下并**自行判断**是否是指纹解锁事件或电源键事件。
  
![image](https://github.com/user-attachments/assets/4463778b-291e-4dc4-a3a8-9312f5d7cf12)  
（如上图为其一，很多机型的指纹解锁事件都不一样。但大部分电源键事件的事件名都为**KEY_POWER**。）  

* 判断后请前往模块路径下**/common/ScreenStatCheck.sh**文件内修改第119行变量值为你在上述操作判断指纹解锁事件对应的**/dev/input/event(N)**文件。
  
* 再修改133行的**grep "0152"**的0152为你判断的指纹解锁事件名。
  
* 执行模块下/service.sh。  

## Note
* Chopin( Redmi Note 10 Pro ) 的指纹解锁事件名为KEY_RIGHT(/dev/input/event4)，电源键事件名为KEY_POWER(/dev/input/event1)
* CAS   ( Xiaomi 10 Ultra   ) 的指纹解锁事件名为0152(/dev/input/event5)，电源键事件名为KEY_POWER(/dev/input/event1)

## 更新日志
* v3.4:
*   更改算法使用循环监测电源键亮屏事件。
* v3.2:
*   更改算法使用循环监测指纹解锁亮屏事件。
* v2.0.0：
*   监听 HyperOS 锁屏触控 **/dev/input/event5** 的 **0152** （因手上没有其他机子尚不清楚该事件是否是通用指纹解锁按钮事件），使得指纹解锁可以正常触发亮屏调度。
* v1.0.0:
*   OUT!!!!!!!!!!!!
