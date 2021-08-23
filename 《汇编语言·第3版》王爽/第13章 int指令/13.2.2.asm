; 编写、安装中断7ch的中断例程
; 功能：将一个全是字母，以0结尾的字符串转化为大写
; 参数：ds:si指向字符串首地址
; 应用举例：将data段中断的字符串转化为大写

assume cs:code,ds:data

data segment
        db "converstaion",0
data ends

code segment

start:          call cpy_int_7ch
                call reg_int_7ch

                mov ax,data
                mov ds,ax
                mov si,0
                int 7ch

                mov ax,4c00h
                int 21h

capital:        push si
convert:        cmp byte ptr ds:[si],0
                je exit
                and byte ptr ds:[si],11011111b
                inc si
                loop convert
exit:           pop si
                iret
capital_end:    nop

; ==============================================================================
; 功能：复制中断7ch的中断例程到指定内存中[cs:ip]<=[0:200]
cpy_int_7ch:    mov ax,cs
                mov ds,ax
                mov si,OFFSET capital
                mov ax,0
                mov es,ax
                mov di,200h
                mov cx,OFFSET capital_end - OFFSET capital
                cld
                rep movsb       ;ds:[si] -> es:[di] 重复[cx]次 复制方向[cld]
                ret
; ==============================================================================
; 功能：把7ch中断例程的入口地址注册到中断向量表中
reg_int_7ch:    mov ax,0
                mov es,ax
                cli     ; Clear Interupt 屏蔽外部中断，提高程序的健壮性
                mov word ptr es:[7ch*4+0],200h  ; set ip
                mov word ptr es:[7ch*4+2],0     ; set cs
                sti     ; Set Interupt 恢复外部中断
                ret
; ==============================================================================

code ends
end start