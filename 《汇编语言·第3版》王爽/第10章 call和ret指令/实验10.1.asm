; 实验10.1 显示字符串
; 应用举例：在屏幕第8行第3列，用绿色显示data段中的字符串
assume cs:code,ds:data

data segment
        db    "Welcome to masm!",0
data ends

code segment

start:          mov ax,data
                mov ds,ax
                mov si,0        ; ds:si指向字符串首地址

                mov dh,8        ; 设置行
                mov dl,3        ; 设置列
                mov cl,10000010b; 设置显示颜色

                call show_str

                mov ax,4c00h    ; 程序退出
                int 21h

; ===================================================================
; 名称：show_str
; 功能：在指定位置，用指定的颜色，显示一个用0结尾的字符串
; 参数： (dh)=行号，0~24
;       (dl)=列号，0~79
;       (cl)=颜色，ds:si指向字符串的首地址
; 返回：无
show_str:       push ax
                push cx
                push dx
                push ds
                push es
                push si
                push di         ; 保存寄存器状态
                call _show_str_set_screen_pos   ; 设置屏幕显示位置
                mov dh,cl       ; 因为要用jcxz，所以把颜色参数转存到dh中
                mov cx,0

        _show_str_loop:
                mov cl,ds:[si]
                jcxz _show_str_exit
                mov dl,cl
                mov word ptr es:[di],dx
                inc si
                add di,2
                jmp _show_str_loop

        _show_str_exit:
                pop di
                pop si
                pop es
                pop ds
                pop dx
                pop cx
                pop ax          ; 恢复寄存器状态
                ret

        _show_str_set_screen_pos:
                mov ax,0b800h
                mov es,ax       ; 计算显示位置  160*(dh)+2*(dl)
                mov al,160
                mul dh
                mov di,ax       ; 设置行
                mov al,2
                mul dl
                add di,ax       ; 设置列
                ret
; ===================================================================

code ends

end start