; 实验3 向内存0:200~0:23F依次传送数据0~63(3FH)
assume cs:code,ds:data,ss:stack

data segment
        db      32 dup (0)
data ends

stack segment stack
        db      32 dup (0)
stack ends

code segment

start:  mov ax,0
        mov ds,ax   ; 数据段地址指向0
        mov bx,200h ; 数据偏移地址指向200h

        mov al,0
        mov cx,64

   s:   mov ds:[bx],al
        inc al
        inc bx
        loop s

        mov ax,4c00h    ; 退出程序
        int 21h

code ends

end start