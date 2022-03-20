; ===========================
; date: 2022-03-16
; ===========================

; 描述符类型
DA_32       EQU    4000h    ; 32 位段

DA_DPL0     EQU      00h    ; DPL = 0
DA_DPL1     EQU      20h    ; DPL = 1
DA_DPL2     EQU      40h    ; DPL = 2
DA_DPL3     EQU      60h    ; DPL = 3

; 存储段描述符类型
DA_DR       EQU    90h    ; 存在的只读数据段类型值
DA_DRW      EQU    92h    ; 存在的可读写数据段属性值
DA_DRWA     EQU    93h    ; 存在的已访问可读写数据段类型值
DA_C        EQU    98h    ; 存在的只执行代码段属性值
DA_CR       EQU    9Ah    ; 存在的可执行可读代码段属性值
DA_CCO      EQU    9Ch    ; 存在的只执行一致代码段属性值
DA_CCOR     EQU    9Eh    ; 存在的可执行可读一致代码段属性值

; 系统段描述符类型
DA_LDT      EQU  82h    ; 局部描述符表段类型值
DA_TaskGate EQU  85h    ; 任务门类型值
DA_386TSS   EQU  89h    ; 可用 386 任务状态段类型值
DA_386CGate EQU  8Ch    ; 386 调用门类型值
DA_386IGate EQU  8Eh    ; 386 中断门类型值
DA_386TGate EQU  8Fh    ; 386 陷阱门类型值

; 宏 ------------------------------------------------------------------------------------------------------
;
; 描述符
; usage: Descriptor Base, Limit, Attr
;        Base:  dd
;        Limit: dd (low 20 bits available)
;        Attr:  dw (lower 4 bits of higher byte are always 0)
%macro Descriptor 3
    dw    %2 & 0FFFFh                ; 段界限1
    dw    %1 & 0FFFFh                ; 段基址1
    db    (%1 >> 16) & 0FFh          ; 段基址2
    dw    ((%2 >> 8) & 0F00h) | (%3 & 0F0FFh)    ; 属性1 + 段界限2 + 属性2
    db    (%1 >> 24) & 0FFh          ; 段基址3
%endmacro ; 共 8 字节

org 7c00h ; 起始地址

jmp LABEL_CODE_16

; 这里的GDT包含的都是代码段和数据段描述符，
; 段基址和段界限比较好理解，标识一个段（代码段或者数据段）从哪里开始，长度是多少
; 属性就比较复杂了，主要是为特权级服务，本例可以先不做理解
[SECTION .gdt] ; GDT段
; 段描述符           宏命令           段基址,       段界限,              属性
LABEL_GDT:          Descriptor      0,           0,                  0
LABEL_DESC_CODE32:  Descriptor      0,           SegCode32Len - 1,   DA_C + DA_32   ; 非一致代码段
LABEL_DESC_VIDEO:   Descriptor      0B8000h,     0ffffh,             DA_DRW         ; 显存首地址
; LABEL_GDT             dw 0000h, 0000h,0000h,0000h
; LABEL_DESC_CODE32     dw 0014h, 0000h,9800h,0040h
; LABEL_DESC_VIDEO      dw 0FFFFh,8000h,920Bh,0000h

; GdtPtr跟GDTR寄存器的结构完全一样 [32位基地址,16位界限]
GdtLen  equ $ - LABEL_GDT   ; GDT长度
GdtPtr  dw GdtLen - 1       ; GDT界限 这是固定的，直接初始化进去
        dd 0                ; GDT基地址 先置0  后面还会来改


; 选择子图示:
    ; ┏━━━━┳━━━━┳━━━━┳━━━━┳━━━━┳━━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━┓
    ; ┃ 15 ┃ 14 ┃ 13 ┃ 12 ┃ 11 ┃ 10 ┃ 9 ┃ 8 ┃ 7 ┃ 6 ┃ 5 ┃ 4 ┃ 3 ┃ 2 ┃ 1 ┃ 0 ┃
    ; ┣━━━━┻━━━━┻━━━━┻━━━━┻━━━━┻━━━━┻━━━┻━━━┻━━━┻━━━┻━━━┻━━━┻━━━╋━━━╋━━━┻━━━┫
    ; ┃                         index                           ┃TI ┃ RPL   ┃
    ; ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━┻━━━━━━━┛
    ;
    ; RPL(Requested Privilege Level): 请求特权级，用于特权检查。
    ;
    ; TI(Table Indicator): 引用描述符表指示位
    ;    TI=0 指示从全局描述符表GDT中读取描述符；
    ;    TI=1 指示从局部描述符表LDT中读取描述符。
; 选择子

SelectorCODE32   equ LABEL_DESC_CODE32 - LABEL_GDT
SelectorVideo    equ LABEL_DESC_VIDEO  - LABEL_GDT

[SECTION .16bit] ; 16位代码段
[BITS 16]
LABEL_CODE_16:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0100h   ; 初始化

    ; 保护模式⑤步走：
    ; ①准备GDT
    xor eax, eax    ; 清零 据说用xor指令清零最快
    mov ax, cs
    shl eax, 4
    add eax, LABEL_SEG_CODE32
    mov word [LABEL_DESC_CODE32 + 2], ax
    shr eax, 16
    mov byte [LABEL_DESC_CODE32 + 4], al
    mov byte [LABEL_DESC_CODE32 + 7], ah

    ; ②加载GDTR
    xor eax, eax
    mov ax, ds
    shl eax, 4
    add eax, LABEL_GDT
    mov dword [GdtPtr + 2], eax
    lgdt [GdtPtr]

    ; ③关中断并打开A20地址线
    cli
    in al, 92h
    or al, 00000010b
    out 92h, al

    ; ④将CR0的PE位置1 进入保护模式
    mov eax,cr0
    or eax,1h
    mov cr0,eax

    ; ⑤jmp跳转到32位代码段
    jmp dword SelectorCODE32:0

[SECTION .32bit]
[BITS 32]
LABEL_SEG_CODE32:

    mov ax, SelectorVideo
    mov es, ax          ; 视频段选择子(目的)

    mov edi, (80 * 11 + 79) * 2    ; 屏幕第 11 行, 第 79 列。
    mov ah, 0Ch         ; 0000: 黑底    1100: 红字
    mov al, 'X'
    mov [es:edi], ax

    jmp $               ; 死循环

SegCode32Len equ $ - LABEL_SEG_CODE32