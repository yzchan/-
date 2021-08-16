; 实验10.3 数值显示
; 应用举例：将数据12666以十进制的形式用绿色显示在屏幕8行3列。

assume cs:code,ds:data,ss:stack

STR_BUFF_SIZE   equ     16

data segment
        db      STR_BUFF_SIZE dup (0)
data ends

stack segment stack
        db      128 dup (0)
stack ends

code segment
start:          mov ax,stack
                mov ss,ax
                mov sp,128

                mov dx,data
                mov ds,dx
                mov si,0
                mov ax,9768h
                mov dx,005Ah
                call ddtoc

                mov dh,8        ; 设置行
                mov dl,3        ; 设置列
                mov cl,10000010b; 设置显示颜色
                call show_str

                mov ax,4c00h
                int 21h

; ===================================================================
; 名称： dwtoc
; 功能： 将word型数据转变为表示十进制的字符串，字符串以0结尾
; 参数： (ax)=word型数据
;       ds:si指向字符串首地址
; 返回：无
dwtoc:          push bx
                push cx
                push dx
                mov dx,0
                mov si,STR_BUFF_SIZE-2

        _dwtoc_loop:
                mov cx,10       ; 除数
                call divdw
                add cx,30h
                mov ds:[si],cl
                mov cx,ax
                jcxz _dwtoc_exit
                sub si,1
                jmp _dwtoc_loop

        _dwtoc_exit:
                pop dx
                pop cx
                pop bx
                ret
; ===================================================================


; ===================================================================
; 名称： ddtoc
; 功能： 将dword型数据转变为表示十进制的字符串，字符串以0结尾
; 参数： (ax)=word型低16位数据
;       (dx)=word型高16数据
;       ds:si指向字符串首地址
; 返回：无
ddtoc:          push bx
                push cx
                push dx
                mov si,STR_BUFF_SIZE-2

        _ddtoc_loop:
                mov cx,10       ; 除数
                call divdw
                add cx,30h
                mov ds:[si],cl
                mov cx,ax
                jcxz _ddtoc_exit
                sub si,1
                jmp _ddtoc_loop

        _ddtoc_exit:
                pop dx
                pop cx
                pop bx
                ret
; ===================================================================


; ===================================================================
; 名称：divdw
; 功能：进行不会产生溢出的触发运算，被除数dword型，除数word型。结果dword型
; 参数： (ax) = dword型数据的低16位
;       (dx) = dword型数据的高16位
;       (cx) = 除数
; 返回： (dx) = 结果的高16位 (ax) = 结果的低16位
;       (cx) = 余数
; 分析： 避免溢出公式：X/N => int(H/N)*65535 + [rem(H/N)*65535+L]/N
;                       int:取整  rem:取余    L:X低16位 H:X高16位
; 使用示例：[dx,ax]÷cx = 商[dx,ax]余cx
divdw:          push bx         ; 保存bx寄存器
                mov bx,ax
                mov ax,dx
                mov dx,0
                div cx          ; ax=商 dx=余数
                push ax
                mov ax,bx
                div cx          ; ax=商 dx=余数
                mov cx,dx
                pop dx
                pop bx          ; 恢复bx寄存器
                ret
; ===================================================================


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