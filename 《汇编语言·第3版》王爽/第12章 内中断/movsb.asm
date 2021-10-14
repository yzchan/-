; 将数据段中的数据复制到0:200处

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
        mov si,0        ; 设置ds:si指向源地址

        mov ax,0
        mov es,ax
        mov di,200h     ; 设置es:di指向目标地址

        mov cx,16       ; 设置cx为复制长度
        cld             ; 设置传输方向为正
        rep movsb       ; 开始传输内存数据
        
        mov ax,4c00h    ; 退出程序
        int 21h

code ends

end start