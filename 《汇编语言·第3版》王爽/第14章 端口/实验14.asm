; 以“年/月/日 时:分:秒”的格式，从CMOS中读取并显示当前的时间
; 实现方式：先从CMOS中读取并计算出正确的时间格式，再用21h中断的9号子程序来将时间显示到光标处
assume cs:code

code segment
        db "YY/MM/DD HH:MM:SS","$"
pos:    db 9,8,7,4,2,0  ; 分别对应cmos中年月日时分秒对应的位置
start:  mov ax,cs
        mov ds,ax

        mov si,OFFSET pos
        mov cx,6
        mov bx,0b800h
        mov es,bx
        mov bx,0

s:      push cx
        mov dl,ds:[si]
        mov al,dl
        out 70h,al      ; 70h为地址端口
        in  al,71h      ; 71h为数据端口

        mov ah,al
        mov cl,4
        shr ah,cl
        and al,00001111b

        add ah,30h
        add al,30h

        mov ds:[bx],ah
        mov ds:[bx+1],al

        inc si
        add bx,3
        pop cx
        loop s

        mov dx,0    ; ds:dx指向data段首地址
        mov ah,9
        int 21h     ; 要显示的字符串需要用$作为结束符

        mov ax,4c00h
        int 21h

code ends

end start