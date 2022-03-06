# 备忘

## MASM和NASM

MASM是微软的，微软早期的MS-DOS就是用的MASM。现在各个版本的VS中也都包含MASM汇编器。

本书用的[NASM](https://www.nasm.us/index.php)是开源的汇编器。

Linux内核使用的是GAS汇编程序(GNU汇编程序)

## 软盘大小

一个1.44M的软盘，它有2个面，每个面80个磁道，每个磁道有18个扇，每个扇区512字节，它的容量：80×18×2×512=1440KB=1.40625MB≈1.44MB

## 引导扇区相关概念：

- FAT12
- MBR的概念
- 结束标识0x550xAA
- 0x7c00

## 磁盘扇区读写工具

- rawrite
- linux dd命令
