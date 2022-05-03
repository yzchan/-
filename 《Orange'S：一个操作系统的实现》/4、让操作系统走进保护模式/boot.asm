
; org  0x7c00	; 也支持传统C语言的0x前缀表示法
org 07c00h	; 但是这种表示法需要注意开头为数字时需要添加前导0，否则编译器无法识别

jmp short LABEL_INIT		; 这里的短跳转只占两个字节
nop							; 这个 nop 不可少

%include "lib/FAT12.inc"

LoaderBase		equ	09000h	; LOADER.BIN 将被加载到的位置（段基址）
LoaderOffset	equ	0100h	; LOADER.BIN 将被加载到的位置（段偏移）

LABEL_INIT:
	mov	ax, cs		; 初始化段寄存器
	mov	ds, ax
	mov	es, ax
	mov	ss, ax		; 初始化栈
	mov	sp, 07c00h

	mov	bx, 0700h	; 黑底白字(BL = 07h)
	mov	cx, 0		; 左上角: (0, 0)
	mov	dx, 0184fh	; 右下角: (80, 50)
	mov	ax, 0600h	; 6号子程序
	int	10h			; 清屏

	mov bh, 0
	mov dh, 0
	mov dl, 0
	mov ah, 2		; BH=页码，DH=行，DL=列
	int 10h			; 置光标位置

	mov ch, 0ah		; 绿色
	mov dx, 0		; DH:行 DL:列
	mov si, Booting
	call DispStr

	jmp LABEL_START

; 变量
Cnt dw 0						; 计数器
LoaderName db 'LOADER  BIN', 0	; loader.bin 在fat根目录中的名称 [FLOWER  TXT] [LOADER  BIN]
LoaderNotFound db 'loader.bin not found!',0
Loading db 'Loading...', 0
Booting db 'Booting...', 0

LABEL_START:
	mov ax, LoaderBase
	mov es, ax
	mov bx, LoaderOffset	; es:bx <- 内存缓冲区

LABEL_LOAD_ROOT:
	cmp word [Cnt], 14		; 读取根FAT12根目录区计数器（共计14个扇区）
	je LABEL_LOADER_NOT_FOUND
	mov ax, [Cnt]
	add ax, 19				; 重新计算位置 根目录区从第18个扇区开始
	mov cl, 1				;
	call ReadSector			;

	; 开始寻找loader.bin文件
	mov si, LoaderName		; ds:si指向文件名
	mov di, LoaderOffset	; es:di -> 9000:100

	mov cx, 16				; 一个扇区16个目录项条目
LABEL_FIND_LOADER_LOOP:
	push cx					; CmpMem也要用到cx 保存下
	mov cx ,11				; cx比较次数 fat12文件名长度11
	call CmpMem
	pop cx
	jz LABEL_START_LOADER	; 找到了文件，此时的es:di指向了该文件的Directory Entry
	add di, 32				; 比较下一项
	loop LABEL_FIND_LOADER_LOOP

	inc word [Cnt]		; 准备读下一个扇区
	jmp LABEL_LOAD_ROOT

LABEL_LOADER_NOT_FOUND:		; 没找到loader.bin
	mov ch, 0dh				; 黑底红字（闪烁+高亮）
	mov dx, 0100h			; DH:行 DL:列
	mov si, LoaderNotFound
	call DispStr			; 打印提示信息
	hlt						; 停机

LABEL_START_LOADER:			; 找到了loader.bin 会跳到这里
	mov ch, 0ah				; 绿色
	mov dx, 0100h			; DH:行 DL:列
	mov si, Loading
	call DispStr			; 先打印提示信息Loading

	mov ax, [es:di+1ah]		; es:di指向查找文件的Directory Entry起始位置  +0x1a 指向该文件的起始簇号DIR_FstClus
	push ax					; 开始查找Entry并加载进内存  ax后面GetFatEntry要用 先进栈保存

	mov ax, LoaderBase		; 将FAT1全部加载进内存缓冲区 共9个扇区
	sub ax, 0200h			; 80000h前开辟8k空间 用来存存fat1的9个扇区
	mov es, ax
	mov bx, 0				; es:bx <- 内存缓冲区
	mov ax, 1				; 从第1个扇区开始
	mov cl, 9				; 载入9个扇区
	call ReadSector
	xchg bx, bx		; magic break
	pop ax ;  此时ax存放了fat数据

	mov bx, LoaderOffset	; 9000:100 <- es:bx
LABEL_FIND_ENTRY_LOOP:
	push es
	push ax
	mov dx, LoaderBase		; 载入内存缓冲区
	mov es, dx
	add ax, 17+14			; 从第?个扇区开始
	mov cl, 1				; 载入1个扇区
	call ReadSector
	pop ax
	pop es
	push bx
	mov bx, 0
	call GetFatEntry
	pop bx
	add bx, 200h		; 载入下一个扇区
	cmp ax, 0FFFh
	jz LABEL_LOADED_OK
	jmp LABEL_FIND_ENTRY_LOOP

LABEL_LOADED_OK:

	jmp	LoaderBase:LoaderOffset			; 将控制权转交到loader

%include	"lib/DispStr.asm"
%include	"lib/ReadSector.asm"
%include	"lib/CmpMem.asm"
%include	"lib/GetFatEntry.asm"

times 	510-($-$$)	db	0	; 填充剩下的空间，使生成的二进制代码恰好为512字节
dw 	0xaa55				; 结束标志
