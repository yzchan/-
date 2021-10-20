; int 10h中断例程 本例使用了2号子程序和0号子程序
assume cs:code

code segment
start:  mov ah,2        ; 设置光标位置
        mov bh,0        ; 第0页
        mov dh,2        ; 行号 80x25字符模式下：0-24
        mov dl,12       ; 列号 80x25字符模式下：0-79
        int 10h

        mov ah,9        ; 光标位置显示字符
        mov al,'!'      ; 显示字符
        mov bl,11001010b; 显示属性
        mov bh,0        ; 第0页
        mov cx,5        ; 字符重复个数
        int 10h

        mov ax,4c00h
        int 21h
code ends
end start