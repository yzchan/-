; ================================================
; 功能：FAT12-根据起始簇号查询下一个簇号
; 入参：
; 	ax	待载入的逻辑扇区号
; 	es:bx FAT内存映射区
; 出参：
; 	ax 下一项簇号
; 备注：暂时只支持1.44m软盘的读取
; ------------------------------------------------
; author: chenyuzou@qq.com
; date: 2022-05-01
; ================================================

GetFatEntry:
	push dx
	push bx			; 保存现场

	push bx			; 先保存bx 后面计算要用bx
	mov	bx, 3		; *3/2 计算簇的位置
	mul	bx			; ax = ax * 3
	mov	bx, 2
	div	bx			; ax/2 =>ax<-商, dx<-余数
	pop bx
	add bx, ax
	mov ax, [es:bx]
	cmp dx, 0
	jz .even
	; 奇数
	shr ax, 4
.even:	; 偶数
	and ax, 0fffh	; 屏蔽最高位

	pop bx			; 恢复现场
	pop dx
	ret
