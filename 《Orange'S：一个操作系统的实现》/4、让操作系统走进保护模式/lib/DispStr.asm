; ================================================
; 功能：显示字符串
; 入参：
; 	dh 行号 dl 列号
; 	ch 颜色
; 	ds:si指向字符串首地址（以0结尾）
; 出参：
; 	无
; ------------------------------------------------
; author: chenyuzou@qq.com
; date: 2022-05-01
; ================================================

DispStr:
	push ax
	push es
	push di
	mov ax,0b800h	; 将es:di指向屏幕输出位置
	mov es,ax
	mov di,0
	mov al,160		; 开始计算di的位置
	mul dh
	add di,ax		; 计算行
	mov al,2
	mul dl
	add di,ax		; 计算列
.loop:
	mov cl, [ds:si]	; 低位显示字符 高位显示属性
	cmp cl,0
	je .end
	mov [es:di],cx
	inc si
	add di,2
	jmp .loop
.end:
	pop di
	pop es
	pop ax
	ret
