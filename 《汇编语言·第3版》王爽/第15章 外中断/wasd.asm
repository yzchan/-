; 按下wasd键时，在屏幕上显示对应字符(尚未完善)
assume cs:code,ds:data,ss:stack

data segment
    db 32 dup (0)
data ends

stack segment stack
    db 32 dup (0)
stack ends

code segment

start:  call cpy_new_int9
        call reg_new_int9

    s:  mov bx,0
        jmp s
        mov ax,4c00h
        int 21h

; ============================================================
; 新的int9中断
; ============================================================
new_int9:
        push ax

        in al,60h

        pushf
        call dword ptr cs:[200h]    ;  进入中断例程时 cs=0  且TF/IF都为0
        ; 下面可以嵌入我们自己的键盘处理逻辑

        cmp al,11h
        je show_w

        cmp al,1eh
        je show_a

        cmp al,1fh
        je show_s

        cmp al,20h
        je show_d
new_int9_ret:
        pop ax
        iret
show_w:
        mov ah,'w'
        call show_char
        ret
show_a:
        mov ah,'a'
        call show_char
        ret
show_s:
        mov ah,'s'
        call show_char
        ret
show_d:
        mov ah,'d'
        call show_char
        ret
show_char:
        push ax
        push dx
        push es
        push di
        mov dx,0b800h
        mov es,dx
        mov di,160*10+2*20
        mov es:[di],ah
        pop di
        pop es
        pop dx
        pop ax
        ret
new_int9_end:
        nop
; ============================================================
; 安装int9中断
; ============================================================
cpy_new_int9:
        mov ax,cs
        mov ds,ax
        mov si,offset new_int9      ;从new_int9标号内存处开始复制
        mov ax,0
        mov es,ax                   ; 复制到0:200处
        mov di,204h
        mov cx,offset new_int9_end - offset new_int9
        cld
        rep movsb
        ret
; ============================================================
; 注册int9中断到中断向量表中
; ============================================================
reg_new_int9:
        mov ax,0
        mov es,ax
        push es:[9*4]
        pop es:[200h]
        push es:[9*4+2]
        pop es:[202h]               ; 先保存老的中断例程入口地址
        cli
        mov word ptr es:[9*4],204h
        mov word ptr es:[9*4+2],0
        sti


        ret

code ends

end start