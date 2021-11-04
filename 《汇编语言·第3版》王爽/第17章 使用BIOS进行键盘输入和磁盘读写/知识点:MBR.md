知识点:MBR
---

主引导记录（MBR，Master Boot Record）是采用MBR分区表的硬盘的第一个扇区，即C/H/S地址的0柱面0磁头1扇区，也叫做MBR扇区。


MBR分区表和GPT分区表

### 常见术语：MBR/GPT/GUID/UEFI/LEGACY
GPT是GUID磁碟分割表（GUID Partition Table）的缩写，含义“全局唯一标识磁盘分区表”，是一个实体硬盘的分区表的结构布局的标准。

UEFI和LEGACY是两种不同的引导方式

uefi是新式的BIOS，legacy是传统BIOS。
在UEFI模式下安装的系统，只能用UEFI模式引导；Legacy模式同理
uefi只支持64为系统且磁盘分区必须为GPT模式，传统BIOS使用int 13中断读取磁盘，每次只能读64KB，非常低效，而UEFI每次可以读1MB，载入更快。

UEFI属于主板类名词，其作用类似于BIOS。GPT、MBR则属于硬盘类名词，它们的作用类似一艘航母的骨架，有了这个骨架，我们才可以进行细致到诸如C、D、E等盘符的分区。

MBR分区表最多只能识别2TB左右的空间，大于2TB的容量将无法识别从而导致硬盘空间浪费，而GPT分区表则能够识别2TB以上的硬盘空间。
MBR分区表最多只能支持4个主分区或三个主分区+1个扩展分区(逻辑分区不限制)，GPT分区表在Windows系统下可以支持128个主分区。


因为硬件发展迅速，传统式（Legacy）BIOS 成为进步的包袱，现在已发展出最新的EFI（Extensible Firmware Interface）可扩展固件接口，以现在传统 BIOS 的观点来说，未来将是一个“没有特定 BIOS”的电脑时代。

UEFI是由EFI1.10为基础发展起来的，它的所有者已不再是Intel，而是一个称作Unified EFI Form（www.uefi.org）的国际组织，贡献者有Intel，Microsoft，AMI，等几个大厂，属于open source，目前版本为2.1。与legacy BIOS 相比，最大的几个区别在于：

1. 编码99%都是由C语言完成；

2. 一改之前的中断、硬件端口操作的方法，而采用了Driver/protocal的新方式；

3. 将不支持X86模式，而直接采用Flat mode（也就是不能用DOS了，现在有些 EFI 或 UEFI 能用是因为做了兼容，但实际上这部分不属于UEFI的定义了）；

4. 输出也不再是单纯的二进制code，改为Removable Binary Drivers；

5. OS启动不再是调用Int19，而是直接利用protocol/device Path；

6. 对于第三方的开发，前者基本上做不到，除非参与BIOS的设计，但是还要受到ROM的大小限制，而后者就便利多了

## 硬盘寻址方式

- C/H/S： 柱面数（Cylinders）、 磁头数（Heads）、扇区数（Sectors）三维寻址模式
- LBA：   LBA(Logical Block Addressing)逻辑块寻址模式