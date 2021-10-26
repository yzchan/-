; 实验16
; 安装一个新的int 7ch中断例程，为显示输出提供如下功能子程序：
;  (1) 清屏
;  (2) 设置前景色
;  (3) 设置背景色
;  (4) 向上滚动一行
; 入口参数如下：
;  (1) 用ah传送功能号
;  (2) 用al传送颜色值
assume cs:code,ds:data,ss:stack

data segment

data ends

stack segment stack
        db 64 dup (0)
stack ends

code segment
start:  mov bx,stack
        mov ss,bx
        mov sp,64
        mov bx,data
        mov ds,bx

        call clearScreen

        mov ax,4c00h
        int 21h

; ===================================================================
; 清屏子程序
; ===================================================================
clearScreen:
        push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000

    c1: mov byte ptr es:[bx+0],0
        mov byte ptr es:[bx+1],00000000b
        add bx,2
        loop c1

        pop es
        pop cx
        pop bx
        ret
code ends
end start