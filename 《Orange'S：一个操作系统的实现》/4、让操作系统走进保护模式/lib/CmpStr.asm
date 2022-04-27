
; 比对两段内存中字符串数据是否相同
; 参数 ds:si指向源地址   es:di指向目标地址  cx比较次数
; 出口参数 ZF=1表示相等  ZF=0表示不等
CmpStr:
	push si
	push di
.CmpStrStart:
	cmpsb
	jnz .CmpStrExit
	loop .CmpStrStart
.CmpStrExit:
	pop di
	pop si
	ret



; 比对两段内存中字符串数据是否相同
; 参数 ds:si指向源地址   es:di指向目标地址  cx比较次数
; 出口参数 ZF=1表示相等  ZF=0表示不等
; CmpStr:
; 	push ax
; 	push si
; 	push di
; .start:
; 	lodsb	; ds:si -> al & inc si
; 	cmp es:[di], al
; 	jnz .exit
; 	inc	di
; 	loop .start
; 	cmp al, al	; 将ZF标志位置1
; .exit:
; 	pop di
; 	pop si
; 	pop ax
; 	ret
