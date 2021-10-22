; 显示键盘状态字  0040:17位置
assume cs:code,ss:stack

data segment
    db 128 dup (0)
data ends

stack segment
    db 128 dup (0)
stack ends

code segment

start:          mov ax,stack
                mov ss,ax
                mov sp,128

                mov ax,40h
                mov ds,ax
                mov si,17h      ; ds:si 指向键盘状态字

                mov ax,0b800h
                mov es,ax
                mov di,160*24+40*2  ; es:di 指向显存

 s:
                call showKeyboardState
                jmp s

                mov ax,4c00h
                int 21h


showKeyboardState:
                push ax
                push cx
                push dx
                push si
                push di
                mov al,ds:[si]
                mov cx,8
        sks:    shl al,1
                mov dx,0
                adc dl,30h
                mov es:[di],dl
                add di,2
                loop sks
                pop di
                pop si
                pop dx
                pop cx
                pop ax
                ret



code ends

end start