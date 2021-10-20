; 在屏幕指定位置显示感叹号！，然后触发0号中断
; 需要在Dos或者xp系统中才能看到效果，在Dosbox中是看不到效果的。
assume cs:code

code segment
start:  mov ax,0b800h
        mov es,ax
        mov byte ptr es:[160*12+40*2],'!'
        int 0   ; 引发0号中断
code ends
end start