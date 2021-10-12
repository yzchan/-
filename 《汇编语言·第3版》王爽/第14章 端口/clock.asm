; 实现一个时钟功能
; 1、清屏（todo）
; 2、从CMOS中读取时间，并显示到屏幕中间，
; 3、然后写一个死循环不停的读取时间并显示时间
; 这样就实现了一个简单地时钟功能

assume cs:code,ds:data,ss:stack

data segment
        TIME    db "YY/MM/DD HH:MM:SS","$"
        POSI    db 9,8,7,4,2,0  ; 分别对应cmos中年月日时分秒对应的位置
data ends

stack segment stack
        db      32 dup (0)
stack ends

code segment

start:          mov ax,stack
                mov ss,ax
                mov sp,32

                mov ax,data
                mov ds,ax

        s:      call showTime
                jmp s

                mov ax,4c00h    ; 退出程序
                int 21h

showTime:       push ax
                push bx
                push cx
                push dx
                push si
                push di
                mov cx,6
                mov bx,0
                mov di,0

        s1:     mov al,POSI[bx]
                call getCmos
                mov TIME[di],ah
                mov TIME[di+1],al
                inc bx
                add di,3
                loop s1

                mov bh,0        ; 设置页面
                mov dl,10       ; 设置光标列
                mov dh,24       ; 设置光标行
                mov ah,02h
                int 10h         ; 10h中断02h号子程序：设置光标位置

                mov dx,0        ; ds:dx指向data段首地址
                mov ah,9
                int 21h         ; 用21h中断的9号子程序来将时间显示到光标处 要显示的字符串需要用$作为结束符

                pop di
                pop si
                pop dx
                pop cx
                pop bx
                pop ax
                ret

getCmos:        out 70h,al
                in al,71h

                mov ah,al
                and al,00001111b
                shr ah,1
                shr ah,1
                shr ah,1
                shr ah,1

                add al,30h
                add ah,30h
                ret

code ends

end start