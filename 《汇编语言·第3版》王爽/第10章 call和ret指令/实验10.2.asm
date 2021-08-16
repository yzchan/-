; 实验10.2 解决除法溢出问题
; 应用举例：计算1000000/10 F4240H/0AH
; 结果：(dx)=0001H (ax)=86A0H (cx)=0000H

assume cs:code,ds:data,ss:stack

data segment
        dd      1000000
data ends

stack segment stack
        db      128 dup (0)
stack ends

code segment

start:          mov ax,stack
                mov ss,ax
                mov sp,128

                mov ax,data
                mov ds,ax

                mov ax,ds:[0]
                mov dx,ds:[2]
                mov cx,10

                mov bx,0FFFFH
                call divdw

                mov ax,4c00h
                int 21h


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

code ends

end start