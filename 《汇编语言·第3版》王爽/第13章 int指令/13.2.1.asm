; 编写、安装中断7ch的中断例程
; 功能：求一个word姓数字的平方
; 参数：(ax)=要计算的数字
; 返回值：dx、ax中分别存放结果的高16位和低16位
; 应用举例：求2*3456^2

assume cs:code

code segment

start:          call cpy_int_7ch
                call reg_int_7ch

                mov ax,3456
                int 7ch
                add ax,ax   ; 结果ax=8000
                adc dx,dx   ; 结果dx=016c

                mov ax,4c00h    ; 退出
                int 21h

sqr:            mul ax
                iret
sqr_end:        nop

; ==============================================================================
; 功能：复制中断7ch的中断例程到指定内存中[cs:ip]<=[0:200]
cpy_int_7ch:    mov ax,cs
                mov ds,ax
                mov si,OFFSET sqr
                mov ax,0
                mov es,ax
                mov di,200h
                mov cx,OFFSET sqr_end - OFFSET sqr
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