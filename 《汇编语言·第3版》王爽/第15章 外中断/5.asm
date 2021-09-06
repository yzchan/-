;  0040：17 单元存储了键盘状态字节  本程序用于显示该内存单元的数据
assume cs:code,ds:data,ss:stack

data segment
    db 128 dup (0)
data ends

stack segment
    db 128 dup (0)
stack ends

code segment

start:      mov ax,stack
            mov ss,ax
            mov sp,128

            call init_reg
            call show_keyboard_status

            mov ax,4c00h
            int 21h

;=======================================================
init_reg:   mov bx,0b800h ; 显示地址
            mov es,bx

            mov bx,40h  ; 目标地址
            mov ds,bx
            ret

;=======================================================
show_status:
            push cx
            push dx
            push ds
            push es
            push si
            push di

            mov cx,8
showStatus:
            mov dx,0
            shl al,1
            adc dx,30h
            mov es:[di],dl
            add di,2
            loop showStatus

            pop di
            pop si
            pop es
            pop ds
            pop dx
            pop cx
            ret
;=======================================================
show_keyboard_status:
            mov si,17h

testA:      mov al,ds:[si]
            mov di,160*10 + 40*2
            call show_status
            jmp testA
            ret

code ends

end start