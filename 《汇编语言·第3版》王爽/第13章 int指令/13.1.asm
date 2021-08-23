; 在屏幕指定位置显示感叹号！，然后触发0号中断
; 注意再dosbox中，最后的0号中断也无法正确执行，具体原因参见12章
assume cs:code

code segment
start:  mov ax,0b800h
        mov es,ax
        mov byte ptr es:[160*12+40*2],'!'
        int 0   ; 引发0号中断
code ends
end start