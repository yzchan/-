; 程序5.6 计算从ffff:0~ffff:b单元中所有数据的和，结果放在dx中
assume cs:code,ds:data,ss:stack

data segment
        db      32 dup (0)
data ends

stack segment stack
        db      32 dup (0)
stack ends

code segment

start:  mov ax,0ffffh
        mov ds,ax
        mov ax,0    ; 用al读取目标内存的字节，然后用ax做累加
        mov bx,0    ; 偏移地址 用于读取数据
        mov cx,12   ; 累加次数
        mov dx,0    ; 结果
   s:   mov al,ds:[bx]
        add dx,ax
        inc bx
        loop s

        mov ax,4c00h    ; 退出程序
        int 21h

code ends

end start