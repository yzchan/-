; ===============================================
; 扇区读取函数
; 本方法没有借助堆栈，int13出错也没有进行任何处理
; 功能：
; 入参：从第 ax 个 Sector 开始, 将 cl 个 Sector 读入 es:bx 中
; 		ax: 待载入的逻辑扇区号
; 		cl: 需要载入的扇区数量
; 		es:bx 内存缓冲区
; 出参：ax 错误码 AH＝00H，AL＝状态代码
; ===============================================
ReadSector:
	push cx
	push dx
	push bx

	mov bl, 18	; bl:除数  ax:被除数
	div bl		; al:商   ah:余数
	mov bl, cl	; bx暂时没用了 cl临时保存到bl
	mov dl, 0	; 驱动器号 软驱从0开始  0:软驱A  1:软驱B  硬盘从80h开始 80h:硬盘C 81h:硬盘D
	mov dh, al	; 磁头号
	and dh, 1
	shr al, 1	; 柱面(磁道号)
	mov ch,al
	inc ah		; 扇区号
	mov cl, ah	; 至此 CHS(磁头-柱面-扇区)都已求出，ax寄存器也可以留作他用
	mov al, bl	; 要读取的扇区数
	mov ah, 2	; 2号子程序表示读取  3号子程序表示写入
	; int13出口参数：AH＝00H，AL＝状态代码
	pop bx
	int 13h

	pop dx
	pop cx
	ret

