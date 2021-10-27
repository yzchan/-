; 实验16
; 安装一个新的int 7ch中断例程，为显示输出提供如下功能子程序：
;  (0号子程序) 清屏
;  (1号子程序) 设置前景色&背景色
;  (2号子程序) 向上滚动一行
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

        mov al,00000010b        ; 颜色
        mov ah,2                ; 功能号
        call setScreen

        mov ax,4c00h
        int 21h

; ===================================================================
; 屏幕操作程序，包含3个子程序
; ===================================================================
setScreen:
        jmp short begin
        maps dw  clear,setColor,lineUp  ; 子程序向量表
begin:  push bx
        cmp ah,3
        ja sret
        mov bx,0
        mov bl,ah
        add bx,bx
        call word ptr maps[bx]
sret:   pop bx
        ret
; ===================================================================
; 清屏子程序
; ===================================================================
clear:
        push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000

    s1: mov byte ptr es:[bx+0],0
        mov byte ptr es:[bx+1],00000000b
        add bx,1
        loop s1

        pop es
        pop cx
        pop bx
        ret

; ===================================================================
; 设置屏幕颜色
; ===================================================================
setColor:
        push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000

    s2: mov byte ptr es:[bx+1],al
        add bx,2
        loop s2

        pop es
        pop cx
        pop bx
        ret

; ===================================================================
; 滚动一行子程序
; ===================================================================
lineUp:
        push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000

    s3: mov dx,es:[bx+80*2]
        mov es:[bx+0],dx
        add bx,2
        loop s3

        pop es
        pop cx
        pop bx
        ret
code ends
end start