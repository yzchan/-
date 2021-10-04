; 实验4.3 将"mov ax,4c00h"之前的指令复制到0:200处
assume cs:code,ds:data,ss:stack

data segment
        db      32 dup (0)
data ends

stack segment stack
        db      32 dup (0)
stack ends

code segment

start:  mov ax,cs
        mov ds,ax
        mov ax,0020h
        mov es,ax
        mov bx,0
        mov cx,23       ; 以后可以用标号来解决复制多少字节的问题

   s:   mov al,[bx]
        mov es:[bx],al
        inc bx
        loop s

        mov ax,4c00h    ; 退出程序
        int 21h

code ends

end start