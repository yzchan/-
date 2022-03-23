# 如何在freedos下利用bochs调试.com程序

执行.com很简单，成功仿真freedos后，只需要将宿主机上的指定目录挂载到floppyb即可共享文件。

## 挂载

```sh
nasm pmtest2.asm -o pmtest2.com # 汇编
sudo mount -o loop pm.img /mnt/floppy # 挂载
sudo cp pmtest2.com /mnt/floppy # 复制
sudo umount /mnt/floppy # 取消挂载
```

上面的命令是针对linux的，macOS上挂载略有区别。

```sh
hdid -nomount pm.img
sudo mount -t msdos /dev/disk2 ~/floppy # 这里的/dev/disk2不是固定的，需要看上面一条命令的输出
```

## 调试

挂载成功之后，便可以在宿主机编译出.com文件，丢到挂载目录然后进入freedos运行。可是直接使用32位debug.exe进行调试，但是无法跟踪 `mov cr0 eax` 指令。

这里分享一种直接利用bochs调试功能对freedos中的.com进行调试的方法

① 首先在bochs配置文件中启用magicbreak功能（添加到行尾即可）：

```ini
magic_break: enabled=1
```

② 然后在源代码中 添加如下指令

```s
org  0100h      ; 位置随便，这里选在开头
xchg  bx, bx    ; 对，就是它（执行到这里就会自动断点到bochs的debug中了）
```

③ 重新汇编生成新的.com共享到freedos中执行就可以愉快的调试了。
