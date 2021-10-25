assume cs:code,ds:data

data segment
a   db 1,2,3,4,5,6,7,8
b   dw 0
c   dw a,b
d   dd a,b,c ; 相当于 c dw offset a,seg a ......
e   dw offset a,seg a
data ends

; 上面数据段的内存布局为
; 01 02 03 04 05 06 07 08 - 00 00 00 00 08 00 00 00
; 6A 07 08 00 6A 07 0A 00 - 6A 07 00 00 6A 07

code segment
start:  mov ax,data
        mov ds,ax

        mov si,0
        mov cx,8
        mov ah,0
    s:  mov al,a[si]
        add b,ax
        inc si
        loop s

        mov ax,4c00h
        int 21h

code ends
end start