; 编写、安装中断7ch的中断例程
; 功能：显示一个用0结束的字符串
; 参数：dh=行号 dl=列号 cl=颜色 ds:si指向字符串首地址
assume cs:code,ds:data

data segment
    db "Welcome to masm",0
data ends

code segment

start:          call cpy_int_7ch
                call reg_int_7ch

                mov dh,10
                mov dl,10
                mov cl,2
                mov ax,data
                mov ds,ax
                mov si,0
                int 7ch

                mov ax,4c00h    ; 退出
                int 21h

showstr:        mul ax
                iret
showstr_end:    nop

; ==============================================================================
; 功能：复制中断7ch的中断例程到指定内存中[cs:ip]<=[0:200]
cpy_int_7ch:    mov ax,cs
                mov ds,ax
                mov si,OFFSET showstr
                mov ax,0
                mov es,ax
                mov di,200h
                mov cx,OFFSET showstr_end - OFFSET showstr
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