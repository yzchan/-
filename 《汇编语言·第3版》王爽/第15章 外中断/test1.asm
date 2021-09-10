; 模拟0号中断例程
assume cs:code

code segment
start:  mov ax,cs
        mov ds,ax
        mov si,offset do0

        mov ax,0
        mov es,ax
        mov di,200h

        mov dx,offset do0end - offset do0

        cld
        rep movsb

        mov ax,0
        mov es,ax
        mov word ptr es:[0*4],200h
        mov word ptr es:[0*4+2],0

        mov ax,4c00h
        int 21h

do0:    jmp short do0start
        db "Divide overflow","$"
do0start: mov ax,cs
        mov ds,ax
        mov si,202h

        call set_screen_pos ; 设置屏幕输出位置
        call newline        ; 换行
        call show_str       ; 显示字符

        mov ax,4c00h        ; 0号中断不能用iret返回，只能直接退出程序
        int 21h

set_screen_pos:
        mov ax,0b800h
        mov es,ax
        mov di,24*160+0
        ret

show_str:
        mov ax,0
        mov ds,ax
        mov dx,202h ; ds:dx指向需要输出的字符串
        mov ah,9
        int 21h     ; 要显示的字符串需要用$作为结束符

newline:
        mov ah,02h
        mov dl,0dh
        int 21h
        mov ah,02h
        mov dl,0ah
        int 21h
        ret

do0end: nop

code ends
end start