# MUSTPlus
## 简介
[MUSTPlus](https://must.plus) 是一款服务澳门科技大学的校园应用。
本应用需要使用配对的服务端进行运作，相关隐私代码已删除，所以您可能无法正确运行项目。代码仅供参考。

## 如何编译
### 需求环境
CocoaPods, Xcode 7+
根目录下 `pod install`,然后打开生成的`MUSTPlus.workspace`
请先补全API接口地址

## 功能
+—————————+  

|  选课系统 |  

+—————————+

         |

         | 获取数据

         |

+———————+

| M+服务端|

+———————+

         |

         | 获取数据

         |

+———————+

| M+客户端|

+———————+

为了安全起见，客户端并不直接向选课系统发起请求。
相关代码已进行模块化，使用MVC架构编写。由于项目开始时间是2015年，有些 API 已经被苹果 `deprecated`，这一点请注意。
![Time Table](https://github.com/MUSTPlus/MUSTPlus/raw/master/preview1.png)
![Bulletin](https://github.com/MUSTPlus/MUSTPlus/raw/master/preview2.png)
![Moment](https://github.com/MUSTPlus/MUSTPlus/raw/master/preview3.png)
![Talk](https://github.com/MUSTPlus/MUSTPlus/raw/master/preview4.png)
![Others](https://github.com/MUSTPlus/MUSTPlus/raw/master/preview5.png)

### 课程表
自动从澳门科技大学的选课系统 COES 中获取数据，并本地持久化。

### 通告
从澳门科技大学通告系统中获取通告。

### 校友圈
实现了一个类似微博的系统，但没有关注。

### 小纸条
调用了融云的即时通信接口，稍作修改。可从校友圈直接与他人聊天，若要修改此项目，请考虑是否允许陌生人发起聊天。

### 其他智慧校园应用
如上图所示

## 协议
GPL v3.0

