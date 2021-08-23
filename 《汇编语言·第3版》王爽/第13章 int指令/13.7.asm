; DOS提供的中断例程
; 21h 4c号子程序：程序返回
; 21h 9号子程序： 在光标处显示字符串
assume cs:code,ds:data

data segment
    db "Welcome to masm","$"
data ends

code segment
start:  mov ah,2    ; 在第0页第5行第12列放置光标
        mov bh,0
        mov dh,5
        mov dl,12
        int 10h

        mov ax,data
        mov ds,ax
        mov dx,0    ; ds:dx指向data段首地址
        mov ah,9
        int 21h     ; 要显示的字符串需要用$作为结束符

        mov ah,4ch
        int 21h
code ends
end start