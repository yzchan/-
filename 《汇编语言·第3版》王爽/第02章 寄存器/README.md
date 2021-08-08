寄存器类别

8086有14个寄存器：AX、BX、CX、DX、SI、DI、SP、BP、IP、CS、SS、DS、ES、PSW。都是16位的寄存器

通用寄存器：AX、BX、CX、DX通常用来存放一般性的数据。并且他们都可以拆分为两个8位寄存器独立使用：
AX AH+AL
BX BH+BL
CX CH+CL
DX DH+DL

偏移地址寄存器：SI、DI、SP、BP

段寄存器：CS、DS、SS、ES

CS:IP程序计数器：永远指向下一条将要被执行的指令地址
PSW程序状态字：保存运算单元ALU在计算过程中产生的进位、溢出或者是不是为零等一系列状态标志
SS:SP 栈顶标记


检测点2.1
1、写出每条汇编指令执行后相关寄存器中的值
```s
mov ax,62627    ;AX=
mov ah,31H      ;AX=
mov al,23H      ;AX=
add ax,ax       ;AX=
mov bx,826CH    ;BX=
mov cx,ax       ;CX=
mov ax,bx       ;AX=
add ax,bx       ;AX=
mov al,bh       ;AX=
mov ah,bl       ;AX=
add ah,ah       ;AX=
add al,6        ;AX=
add al,al       ;AX=
mov ax,cx       ;AX=
```

2、只能使用目前学过的汇编指令，最多使用4条指令，编程计算2的4次方。
```s
mov ax,2
add ax,ax
add ax,ax
add ax,ax
```

检测点2.2
1、给定段地址为0001H，仅通过变化偏移地址寻址，CPU的寻址范围为__。

2、有一条数据存放在内存20000H单元中，现给定段地址为SA，若想用偏移地址寻找到此单元，则SA应满足条件：最小为__，最大为__。

检测点2.3
下面3条指令执行后，CPU几次修改IP寄存器？都是在什么时候？最后IP中的值是多少？
```s
mov ax,bx
sub ax,ax
jmp ax
```