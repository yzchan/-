; ==============================================
; 用栈存储 优化了书中的逻辑。读取扇区只重试5次
; ax ah-al  子程序号-要读的扇区数  0204
; bx es:bx  内存缓冲区            0000
; cx ch-cl  柱面号-扇区号         0005
; dx dh-dl  磁头号-驱动器号       0100
ReadSector:
	push bp
	mov bp, sp
	sub bp, 4	; 开辟4个字节 存两个数据

	mov [bp-2], cx
	mov word [bp-4], 5	; 重复读取次数

	push bx
	mov	bl, 18    ; (可选入参) bl:除数  ax:被除数
	div	bl        ; al:商   ah:余数
	mov dl, 0     ; (可选入参) 驱动器号 软驱从0开始  0:软驱A  1:软驱B  硬盘从80h开始 80h:硬盘C 81h:硬盘D
	mov dh, al    ; 磁头号
	and	dh, 1
	shr al, 1     ; 柱面(磁道号)
	mov ch,al
	inc	ah       ; 扇区号
	mov cl, ah   ; 至此 CHS(磁头-柱面-扇区)都已求出

	pop bx
.loop:
	cmp word [bp-4], 0
	jz .end
	mov al, [bp-2]; 要读取的扇区数
	mov ah, 2     ; 2号子程序表示读取  3号子程序表示写入
	int 13h       ; int 13会改变ax的值 所以循环读取的时候需要重新设置ax
	dec word [bp-4]
	jc .loop      ; 如果读取错误 CF 会被置为 1,
.end:
	pop bp
	ret
