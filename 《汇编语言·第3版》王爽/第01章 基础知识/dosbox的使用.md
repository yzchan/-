DOSBox的使用
-----

### 简介
DOSBox是一个DOS模拟程序，最新版本已经支持 Windows、Linux、Mac OS X、Android 等众多操作系统。

### 下载
[DOSBox官网](https://www.dosbox.com/)

### 配置
每次打开dosbox都需要运行mount命令，可以通过修改配置让dosbox打开时自动运行。以MacOS为例，打开`~/Library/Preferences/DOSBox\ 0.74-3-3\ Preferences`配置文件，在文件最后添加两行：
```shell
mount c ~/asm
c:
```