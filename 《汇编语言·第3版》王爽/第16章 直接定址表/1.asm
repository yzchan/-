; 使用直接定址表的方式显示十六进制数
assume cs:code,ss:stack

stack segment
    db 128 dup (0)
stack ends

code segment

start:          mov ax,stack
                mov ss,ax
                mov sp,128

                mov al,0Fdh
                call showHex

                mov ax,4c00h
                int 21h

showHex:        jmp short show
                map db "0123456789ABCDEF"
        show:   push ax
                push bx
                push es
                push di
                mov ah,al
                and al,00001111b
                shr ah,1
                shr ah,1
                shr ah,1
                shr ah,1

                mov bx,0
                mov bl,ah
                mov ah,map[bx]
                mov bl,al
                mov al,map[bx]

                mov bx,0b800h
                mov es,bx
                mov di,160*13+40*2
                mov byte ptr es:[di+0],"0"
                mov byte ptr es:[di+2],"x"
                mov es:[di+4],ah
                mov es:[di+6],al
                pop di
                pop es
                pop bx
                pop ax
                ret


code ends

end start