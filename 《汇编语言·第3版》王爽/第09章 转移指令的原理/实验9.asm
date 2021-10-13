; 实验9
; 编程：在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串'welcome to masm!'
; 知识点：显示控制
assume cs:code,ds:data,ss:stack

data segment
STR     db      'welcome to masm!'
data ends

stack segment stack
        db      64 dup (0)
stack ends

code segment

    start:
        mov ax,stack
        mov ss,ax
        mov sp,64

        mov ax,data
        mov ds,ax
        
        mov al,12               ; 设置显示行
        mov ah,30               ; 设置显示列
        mov dh,00000010b        ; 设置显示属性：黑底绿字
        call showString

        mov al,13
        mov ah,30
        mov dh,00100100b        ; 绿底红色
        call showString

        mov al,14
        mov ah,30
        mov dh,01110001b        ; 白底蓝色
        call showString

        mov ax,4c00h    ; 退出程序
        int 21h

; ==============================================
; 显示字符串调用
; 入参 al:显示行 ah:显示列 dh:显示属性
showString:
        push bx
        push cx
        push es
        push si         ; 保存现场

        push dx
        mov dx,ax
        mov si,0
        mov al,160
        mul dl
        add si,ax
        mov al,2
        mul dh
        add si,ax       ; 计算显示位置
        pop dx

        mov ax,0b800h   
        mov es,ax

        mov cx,16
        mov bx,0

    s:  mov dl,STR[bx]
        mov es:[si],dx
        inc bx
        add si,2
        loop s

        pop si          ; 恢复现场并返回
        pop es
        pop cx
        pop bx
        ret
; ==============================================

code ends

end start