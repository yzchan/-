assume cs:code,ds:data,ss:stack

data segment
    db 'Basic'
    db 'iNfOrMaTiOn'
data ends

stack segment stack
    db 32 dup (0)
stack ends

code segment
start:  mov ax,stack    ; 设置栈
        mov ss,ax
        mov sp,32

        mov ax,data
        mov ds,ax
        mov bx,0

        mov cx,5        ; 第一个单词改成大写
    u:  and byte ptr ds:[bx],11011111B
        inc bx
        loop u

        mov cx,11       ; 第二个单词改成小写
    l:  or byte ptr ds:[bx],00100000B
        inc bx
        loop l

        mov ax,4c00h    ; 程序结束
        int 21h
code ends

end start