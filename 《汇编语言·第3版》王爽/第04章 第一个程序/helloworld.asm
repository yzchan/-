assume cs:code,ds:data,ss:stack

data segment
        db      64 dup (0)
data ends

stack segment stack
        db      64 dup (0)
stack ends

code segment

    start:
        mov ax,2
        add ax,ax
        add ax,ax

        mov ax,4c00h    ; 退出程序
        int 21h

code ends

end start