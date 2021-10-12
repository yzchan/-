; 程序模板
assume cs:code,ds:data,ss:stack

data segment
        db      64 dup (0)
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
        
        ;...

        mov ax,4c00h    ; 退出程序
        int 21h

code ends

end start