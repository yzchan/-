; 有点乱，但是基本实现了字符串输入的功能
assume cs:code,ds:data,ss:stack


data segment

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

s:      call get_char
        cmp ah,0eh      ; 退格键
        je backspace    ; 退格键删除字符
        cmp ah,1ch      ; 回车键
        je  exit        ; 回车结束程序
        cmp al,20h      ; 判断是否控制字符
        ja inputchar    ; 非控制字符跳字符输入处理逻辑
        jmp s

backspace:      ; 删除字符
        mov ah,1
        call stringIO   ; 字符弹出
        mov ah,2
        call stringIO   ; 显示
        jmp s

inputchar:      ; 输入字符
        mov ah,0
        call stringIO   ; 字符入栈
        mov ah,2
        call stringIO   ; 显示
        jmp s

exit:
        mov ax,4c00h
        int 21h

get_char:
        mov ah,0
        int 16h
        ret

stringIO:
        jmp string_start

        STACK_STR db 16 dup(0)
        STACK_TOP dw 0
        FUNC_MAP  dw push_char,pop_char,show_string

string_start:
        push ax
        push bx
        push cx
        push dx
        push ds
        push es
        push si
        push di

        cmp ah,2
        ja string_ret
        mov bx,0
        mov bl,ah
        add bx,bx
        jmp word ptr FUNC_MAP[bx]

push_char:
        cmp STACK_TOP,16
        je string_ret
        mov bx,STACK_TOP
        mov STACK_STR[bx],al
        inc STACK_TOP
        jmp string_ret

pop_char:
        cmp STACK_TOP,0
        je string_ret
        dec STACK_TOP
        mov bx,STACK_TOP
        mov STACK_STR[bx],0
        jmp string_ret

show_string:
        mov bx,0b800h
        mov es,bx
        mov cx,80
        mov si,0
s1:     mov byte ptr es:[160*24+si],0
        add si,2
        loop s1
        mov dh,00000010b; 设置显示颜色
        mov cx,STACK_TOP
        inc cx
        mov di,0
        mov si,0
s2:     mov dl,STACK_STR[di]
        mov es:[160*24+si],dx
        add di,1
        add si,2
        loop s2

string_ret:
        pop di
        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax
        ret

code ends

end start