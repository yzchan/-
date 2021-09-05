;  0040：17 单元存储了键盘状态字节  本程序用于显示该内存单元的数据
assume cs:code,ds:data,ss:stack

data segment
    dw 0,0
data ends

stack segment
    db 128 dup (0)
stack ends

code segment

start:          mov ax,stack
                mov ss,ax
                mov sp,128

                mov ax,data
                mov ds,ax

                mov ax,0
                mov es,ax

                ; 保存原来的int9入口地址到ds:[0]中
                push es:[9*4]
                pop ds:[0]
                push es:[9*4+2]
                pop ds:[2]

                ;  设置新的int9入口
                cli
                mov word ptr es:[9*4],offset int9
                mov es:[9*4+2],cs
                sti

                mov ax,0b800h
                mov es,ax
                mov ah,"a"

        s:      mov es:[160*12+40*2],ah
                call delay
                inc ah
                cmp ah,"z"
                jna s

                mov ax,0
                mov es,ax

                push ds:[0]
                pop es:[9*4]
                push ds:[2]
                pop es:[9*4+2]          ; 将中断向量表中的int 9中断例程入口恢复为原来的地址

                mov ax,4c00h
                int 21h


delay:  push dx
        push ax
        push cx
        push ax
        mov dx,0FFFFh
        mov ax,0
s1:     sub ax,1
        sbb dx,0
        cmp ax,0
        loop s1
        pop ax
        pop cx
        pop cx
        pop dx
        ret
; delay:          push ax
;                 push dx
;                 mov dx,1000h
;                 mov ax,0
;         s1:     sub ax,1
;                 sbb dx,0
;                 cmp ax,0
;                 jne s1
;                 cmp dx,0
;                 jne s1
;                 pop dx
;                 pop ax
;                 ret

int9:           push ax
                push bx
                push es
                in al,60h
                pushf
                ; pushf
                ; pop bx
                ; and bh,11111100b
                ; push bx
                ; popf
                call dword ptr ds:[0]

                cmp al,1
                jne int9ret

                mov ax,0b800h
                mov es,ax
                inc byte ptr es:[160*12+40*2+1]

int9ret:        pop es
                pop bx
                pop ax
                iret

code ends

end start