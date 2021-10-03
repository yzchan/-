; 实验4.2 向内存0:200~0:23F依次传送数据0~63(3FH)，且只能很使用9条指令
assume cs:code,ds:data,ss:stack

data segment
        db      32 dup (0)
data ends

stack segment stack
        db      32 dup (0)
stack ends

code segment

start:  mov ax,20h
        mov ds,ax
        mov bx,0         ; 数据段寄存器指向20h:0（也就是0:200h）

        mov cx,64
   s:   mov ds:[bx],bl
        inc bl
        loop s

        mov ax,4c00h    ; 退出程序
        int 21h

code ends

end start