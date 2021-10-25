; 使用直接定址表的方式显示十六进制数
assume cs:code,ss:stack

stack segment
    db 128 dup (0)
stack ends

code segment

start:  mov ax,stack
        mov ss,ax
        mov sp,128

        mov al,0FDh
        call showHex

        mov ax,4c00h
        int 21h

; ===================================================================
; 将十六进制数显示到屏幕上的子程序
; 入参：al中存放待显示的十六进制数
; ===================================================================
showHex:jmp short show
        map db "0123456789ABCDEF"       ; 直接定址表
show:   push ax
        push bx
        push cx
        push dx
        push es
        push di                         ; 保存用到的寄存器

        mov ah,al
        and al,00001111b
        mov cl,4
        shr ah,cl                       ; 将十六进制数的高位和低位分别拆分到ah和hl中

        mov dx,0b800h
        mov es,dx
        mov di,160*24                   ; 设置屏幕的显示位置

        mov byte ptr es:[di+0],'0'
        mov byte ptr es:[di+2],'x'      ; 将十六进制数显示成"0xFF"的形式
        mov bx,0
        mov bl,ah
        mov ah,map[bx]                  ; 利用直接定址表找到十六进制数高位对应的字符
        mov es:[di+4],ah                ; 显示十六进制数高位
        mov bl,al
        mov al,map[bx]                  ; 利用直接定址表找到十六进制数低位对应的字符
        mov es:[di+6],al                ; 显示十六进制数低位

        pop di
        pop es
        pop dx
        pop bx
        pop cx
        pop ax                          ; 恢复用到的寄存器
        ret

code ends

end start