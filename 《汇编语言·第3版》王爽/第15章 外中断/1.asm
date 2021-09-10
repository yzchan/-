assume cs:code

code segment
start:  mov bx,0b800h
        mov es,bx
        mov di,160*12+40*2

        mov ah,"a"

s:      mov es:[di],ah
        inc ah
        add di,2
        cmp ah,"z"
        jna s

        mov ax,4c00h
        int 21h

code ends
end start