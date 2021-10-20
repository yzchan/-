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

                mov dh,24               ; 行号
                mov dl,0                ; 列号
                mov cl,10001010b        ; 颜色
                mov ax,data
                mov ds,ax
                mov si,0                ; ds:si指向字符串首地址
                int 7ch

                mov ax,4c00h            ; 退出程序
                int 21h

; ==============================================================================
; 新的7ch中断例程
; ==============================================================================
new_7ch:        push ax
                push es
                push di
                mov ax,0b800h
                mov es,ax
                mov di,0                ; 将es:di指向屏幕输出位置
                mov al,160              ; 开始计算di的位置
                mul dh
                add di,ax               ; 计算行
                mov al,2
                mul dl
                add di,ax               ; 计算列

        s:      mov ch,ds:[si]
                cmp ch,0
                je se
                mov es:[di],ch          ; 显示字符
                mov es:[di+1],cl        ; 显示属性
                inc si
                add di,2
                jmp s
        se:     pop di
                pop es
                pop ax
                iret
new_7ch_end:    nop

; ==============================================================================
; 功能：复制中断7ch的中断例程到指定内存中[cs:ip]<=[0:200]
; ==============================================================================
cpy_int_7ch:    mov ax,cs
                mov ds,ax
                mov si,OFFSET new_7ch
                mov ax,0
                mov es,ax
                mov di,200h
                mov cx,OFFSET new_7ch_end - OFFSET new_7ch
                cld
                rep movsb               ;ds:[si] -> es:[di] 重复[cx]次 复制方向[cld]
                ret
; ==============================================================================
; 功能：把7ch中断例程的入口地址注册到中断向量表中
; ==============================================================================
reg_int_7ch:    mov ax,0
                mov es,ax
                cli                     ; Clear Interupt 屏蔽外部中断，提高程序的健壮性
                mov word ptr es:[7ch*4+0],200h  ; 低位偏移地址
                mov word ptr es:[7ch*4+2],0     ; 高位段地址
                sti                     ; Set Interupt 恢复外部中断
                ret
; ==============================================================================

code ends
end start