; 实验14
; ===================================================================
; 实验目标：编程，以“年/月/日 时:分:秒”的格式，显示当前的日期、时间
; 实现方法：从CMOS中读取时间信息，并使用21h中断的9号子程序来将时间显示到屏幕上
; 需要知识点：端口处理（in/out指令）、CMOS时间信息、BCD码的处理、21h中断9号子程序
; ===================================================================
assume cs:code,ds:data,ss:stack

data segment
TIME    db "YY/MM/DD HH:MM:SS","$"
POSI    db 9,8,7,4,2,0  ; 分别对应cmos中年月日时分秒对应的位置
data ends

stack segment stack
        db 16 dup (0)
stack ends

code segment

start:  mov ax,stack
        mov ss,ax
        mov sp,16       ; 设置ss:sp指向栈段

        mov ax,data
        mov ds,ax       ; 设置ds指向数据段

        mov cx,6
        mov si,0
        mov di,0

     s: mov al,POSI[si]
        inc si
        out 70h,al
        in al,71h

        mov ah,al
        shr ah,1        ; push cx 
        shr ah,1        ; mov cl,4
        shr ah,1        ; shr ah,cl     ;也可以直接右移四位，但是要注意处理cx
        shr ah,1        ; pop cx

        and al,00001111b

        add ah,30h
        add al,30h      ; 转化为对应字符串的ascii码
 
        mov TIME[di],ah  
        mov TIME[di+1],al  
        add di,3
        loop s

        mov dx,0        ; ds:dx指向data段首地址
        mov ah,9
        int 21h         ; 用21h中断的9号子程序来将时间显示到光标处 要显示的字符串需要用$作为结束符

        mov ax,4c00h    ; 退出程序，将控制权交还给DOS
        int 21h

code ends

end start