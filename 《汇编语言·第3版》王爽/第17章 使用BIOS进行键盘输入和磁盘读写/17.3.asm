; 有点乱，但是基本实现了字符串输入的功能
assume cs:code,ds:data,ss:stack

STR_LEN EQU 5

data segment
CHARS db STR_LEN dup(0)
INDEX dw 0
data ends

stack segment stack
        db 128 dup (0)
stack ends

code segment
start:
        mov ax,data
        mov ds,ax

        mov ax,stack
        mov ss,ax
        mov sp,128

s:      mov ah,0
        int 16h

        cmp al,20h
        jb notchar
        mov dl,al
        call char_push

sh:
        call show_str
        jmp s

notchar:
        cmp ah,0eh      ;退格键
        je backspace
        cmp ah,1ch      ;回车键
        je  sret
        jmp s

backspace:
        call char_pop
        mov byte ptr es:[160*24+10*2+si],0
        jmp sh


char_push:
        cmp INDEX,STR_LEN
        je exit1
        mov bx,INDEX
        mov CHARS[bx],dl
        inc INDEX
exit1:  ret

char_pop:
        cmp INDEX,0
        je exit
        dec INDEX
        mov bx,INDEX
        mov CHARS[bx],0
exit:   ret


sret:   mov ax,4c00h
        int 21h


show_str:
        push bx
        push cx
        push dx
        push es
        push di
        push si
        mov bx,0b800h
        mov es,bx
        mov cx,80
        mov si,0
s1:     mov byte ptr es:[160*24+si],0
        add si,2
        loop s1
        mov dh,00000010b; 设置显示颜色
        mov cx,INDEX
        inc cx
        mov di,0
        mov si,0
s2:     mov dl,CHARS[di]
        mov es:[160*24+si],dx
        add di,1
        add si,2
        loop s2

        ; mov dh,10000010b; 设置显示颜色
        ; mov dl,"_"
        ; mov es:[160*24+si-2],dx
        pop si
        pop di
        pop es
        pop dx
        pop cx
        pop bx
        ret
code ends

end start