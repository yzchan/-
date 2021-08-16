; 将实验7中的数据按照格式显示到屏幕上
; 分析：以实验7为基础，结合实验10的3个子程序即可实现课程设计一

assume cs:code,ds:data,ss:stack

NUM_YEARS equ 21
STR_BUFF_SIZE   equ     16

data segment
    ; 年份
    db    '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db    '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db    '1993','1994','1995'
    ; 收入
    dd    16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd    345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ; 雇佣人数
    dw    3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw    11542,14430,15257,17800
data ends

table segment
                               ;0123456789ABCDEF
        db      NUM_YEARS dup ('year summ ne ?? ')
table ends

string segment
        db      STR_BUFF_SIZE dup (0)
string ends

stack segment stack
        db      128 dup (0)
stack ends

code segment

start:          mov ax,stack
                mov ss,ax
                mov sp,128

                mov ax,data
                mov ds,ax
                mov ax,table
                mov es,ax

                mov si,0
                mov di,NUM_YEARS*4
                mov bx,NUM_YEARS*4*2
                mov bp,0

                mov cx,NUM_YEARS

        s:      push ds:[si]
                pop es:[bp]
                push ds:[si+2]
                pop es:[bp+2]
                add si,4        ; 处理年份
                mov ax,0
                mov es:[bp+4],ax ; 年份字符串后面设置为0  方便调用show_str

                push ds:[di]
                push ds:[di+2]
                pop es:[bp+7]
                pop es:[bp+5]   ; 处理收入

                push ds:[bx]
                pop es:[bp+0ah] ; 处理人数

                mov ax,ds:[di]
                mov dx,ds:[di+2]
                div word ptr ds:[bx]
                mov es:[bp+0dh],ax      ; 处理人均

                add di,4
                add bx,2

                add bp,10h  ; es换行
                loop s
                ; 循环结束  此时数据都在table段中
                ; 下面再把table段中的数据显示到屏幕上

                mov cx,NUM_YEARS
                mov bx,0

        s1:     push cx

                mov dh,NUM_YEARS + 2    ; 从第二行开始显示
                sub dh,cl        ; 设置行

                ; 显示年份
                mov ax,es
                mov ds,ax
                mov ax,bx
                mov si,ax
                mov dl,10        ; 设置列
                mov cl,00000011b; 设置显示颜色
                call show_str

                mov ax,string
                mov ds,ax
                mov si,0

                ; 显示员工数
                mov ax,es:[bx+10]
                push dx
                mov dx,0
                call ddtoc
                pop dx
                mov dl,20        ; 设置列
                mov cl,00000010b; 设置显示颜色
                call show_str

                ; 显示收入
                mov ax,es:[bx+5]
                push dx
                mov dx,es:[bx+7]
                call ddtoc
                pop dx
                mov dl,30        ; 设置列
                mov cl,00000101b; 设置显示颜色
                call show_str

                ; 显示人均
                mov ax,es:[bx+13]
                push dx
                mov dx,0
                call ddtoc
                pop dx
                mov dl,40        ; 设置列
                mov cl,00000100b; 设置显示颜色
                call show_str

                add bx,16
                pop cx
                loop s1

        mov ax,4c00h
        int 21h

print_line:

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