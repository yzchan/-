# 搭建开发环境

## Bochs

[Bochs官网](https://bochs.sourceforge.io/)。也可以去[sourceforge]((https://sourceforge.net/projects/bochs/))下载。特点是仿真了X86的整个平台，包括I/O设备、内存和BIOS，速度慢，但是支持调试，所以很适合学习使用。


### Bochs调试

掌握bochs的调试方法，bochs带的调试命令不多，可以用help查看。

```text
help
h|help - show list of debugger commands
h|help command - show short command description
-*- Debugger control -*-
    help, q|quit|exit, set, instrument, show, trace, trace-reg,
    trace-mem, u|disasm, ldsym, slist
-*- Execution control -*-
    c|cont|continue, s|step, p|n|next, modebp, vmexitbp
-*- Breakpoint management -*-
    vb|vbreak, lb|lbreak, pb|pbreak|b|break, sb, sba, blist,
    bpe, bpd, d|del|delete, watch, unwatch
-*- CPU and memory contents -*-
    x, xp, setpmem, writemem, crc, info,
    r|reg|regs|registers, fp|fpu, mmx, sse, sreg, dreg, creg,
    page, set, ptime, print-stack, ?|calc
-*- Working with bochs param tree -*-
    show "param", restore
```

书上的dump_cpu命令在bochs 2.3.5以上的版本就没有了，可以使用r/sreg/dreg/creg等命令替代。

## 在macOS上安装bochs

编译安装或者直接使用brew安装

```shell
brew install bochs
```

配置环境变量$BXSHARE

```shell
export BXSHARE=/usr/local/share/bochs/
export PATH="$BXSHARE:$PATH"
```

bochs配置文件中添加如下配置才能正确启动bochs窗口

```ini
display_library: sdl2
```


## Virtual Box

还需要一个快一点的虚拟机，，可以直接使用Virtual Box或者VM Ware。（书上推荐的是QEMU，没用过，应该差不多）。