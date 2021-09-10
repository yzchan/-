assume cs:code

stack segment
    db 128 dup (0)
stack ends

code segment

start:  mov ax,stack
        mov ss,ax
        mov sp,128

        mov bx,0b800h
        mov es,bx
        mov di,160*12+40*2

        mov cx,0

        mov ah,"a"
s:      mov es:[di],ah
        call delay
        inc ah
        add di,2
        cmp ah,"z"
        jna s

        mov ax,4c00h
        int 21h

delay:  push ax
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
        ret


code ends

end start