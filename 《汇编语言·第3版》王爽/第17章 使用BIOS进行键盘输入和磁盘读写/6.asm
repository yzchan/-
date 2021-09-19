; 出口参数：AH＝00H，AL＝状态代码，其定义如下：
; 00H — 无错
; 01H — 非法命令
; 02H — 地址目标未发现
; 03H — 磁盘写保护(软盘)
; 04H — 扇区未发现
; 05H — 复位失败(硬盘)
; 06H — 软盘取出(软盘)
; 07H — 错误的参数表(硬盘)
; 08H — DMA越界(软盘)
; 09H — DMA超过64K界限
; 0AH — 错误的扇区标志(硬盘)
; 0BH — 错误的磁道标志(硬盘)
; 0CH — 介质类型未发现(软盘)
; 0DH — 格式化时非法扇区号(硬盘)
; 0EH — 控制数据地址目标被发现(硬盘)
; 0FH — DMA仲裁越界(硬盘)
; 10H — 不正确的CRC或ECC编码
; 11H — ECC校正数据错(硬盘)
; 　CRC:Cyclic Redundancy Check code
; 　ECC:Error Checking & Correcting code
; 20H — 控制器失败
; 40H — 查找失败
; 80H — 磁盘超时(未响应)
; AAH — 驱动器未准备好(硬盘)
; BBH — 未定义的错误(硬盘)
; CCH — 写错误(硬盘)
; E0H — 状态寄存器错(硬盘)
; FFH — 检测操作失败(硬盘)

assume cs:code,ds:data,ss:stack

data segment

data ends

stack segment stack
        db 128 dup (0)
stack ends

code segment
start:
        mov ax,stack
        mov ss,ax
        mov sp,128

        ; mov ax,0
        ; mov ds,ax
        ; mov byte ptr ds:[200h],"a"

        mov ax,0
        mov es,ax
        mov bx,200h

        mov al,1
        mov ch,0
        mov cl,1
        mov dl,0
        mov dh,0

        mov ah,2
        int 13h

        mov ax,4c00h
        int 21h
code ends

end start