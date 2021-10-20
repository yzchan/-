; 编写、安装中断7ch的中断例程
; 功能：将一个全是字母，以0结尾的字符串转化为大写
; 参数：ds:si指向字符串首地址
; 应用举例：将data段中的字符串转化为大写，并显示到屏幕上

assume cs:code,ds:data

data segment
        db "converstaion",0
data ends

code segment

start:          call cpy_int_7ch        ; 复制新的7ch中断例程到安全的内存空间
                call reg_int_7ch        ; 注册新的7ch中断例程入口到中断向量表

                mov ax,data
                mov ds,ax
                mov si,0
                int 7ch                 ; 调用7ch中断例程

                call show               ; 显示到终端

                mov ax,4c00h
                int 21h

; ==============================================================================
; 显示字符串
; ==============================================================================
show:           mov ax,0b800h
                mov es,ax
                mov di,160*24 + 2*0
        s:      mov cl,ds:[si]
                mov ch,0
                jcxz se                         ; 用jcxz循环
                mov es:[di],cl
                mov byte ptr es:[di+1],00000010b
                inc si
                add di,2
                jmp s
        se:     ret
; ==============================================================================
; 7ch中断例程
; ==============================================================================
capital:        push si
convert:        cmp byte ptr ds:[si],0
                je exit                         ; 用cmp配合je循环
                and byte ptr ds:[si],11011111b
                inc si
                jmp convert
exit:           pop si
                iret
capital_end:    nop

; ==============================================================================
; 功能：复制中断7ch的中断例程到指定内存中[cs:ip]<=[0:200]
; ==============================================================================
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
; ==============================================================================
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