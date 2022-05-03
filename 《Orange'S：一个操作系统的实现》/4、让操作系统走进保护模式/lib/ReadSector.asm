; ================================================
; 功能：从第ax个扇区开始, 将cl个扇区读入[es:bx]中
; 入参：
; 	ax	待载入的逻辑扇区号
; 	cl	需要载入的扇区数量
; 	es:bx 内存缓冲区
; 出参：（与int13h 02号子程序出参相同）
; 	cf=0 成功  ah=00h al=传输的扇区数
; 	cf=1 失败  ah=状态代码
; 备注：暂时只支持1.44m软盘的读取
; ------------------------------------------------
; author: chenyuzou@qq.com
; date: 2022-05-01
; ================================================

ReadSector:
	push bp
	mov bp, sp
	sub bp, 4	; 开辟4个字节 存两个数据

	mov [bp-2], cx
	mov word [bp-4], 5	; 重复读取次数

	push bx
	mov	bl, 18	; (可选入参) bl:除数  ax:被除数
	div	bl		; al:商   ah:余数
	mov dl, 0	; (可选入参) 驱动器号 软驱从0开始  0:软驱A  1:软驱B  硬盘从80h开始 80h:硬盘C 81h:硬盘D
	mov dh, al	; 磁头号
	and	dh, 1
	shr al, 1	; 柱面(磁道号)
	mov ch,al
	inc	ah		; 扇区号
	mov cl, ah	; 至此 CHS(磁头-柱面-扇区)都已求出

	pop bx
.loop:
	cmp word [bp-4], 0
	jz .end
	mov al, [bp-2]	; 要读取的扇区数
	mov ah, 2		; 2号子程序表示读取  3号子程序表示写入
	int 13h			; int 13会改变ax的值 所以循环读取的时候需要重新设置ax
	dec word [bp-4]
	jc .loop
.end:
	pop bp
	ret
