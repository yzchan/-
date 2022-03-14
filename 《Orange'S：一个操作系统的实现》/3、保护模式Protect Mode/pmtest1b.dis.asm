00000100  E92100            jmp 0x124
          00 填充字节

=====LABEL_GDT
00000104  0000 0000 0000 0000

0000010C  1400 0000 0098 4000

00000113  FFFF 0080 0B92 0000

=====GdtPtr
0000011C  170000000000
00000121  0000  填充字节

=====LABEL_BEGIN
00000124  8CC8          mov	ax, cs
          8ED8          mov	ds, ax
00000128  8EC0          mov	es, ax
          8ED0          mov	ss, ax
0000012C  BC0001        mov	sp, 0100h

0000012F  6631C0            xor eax,eax
00000132  8CC8              mov ax,cs
00000134  66C1E004          shl eax,byte 0x4
00000138  660580010000      add eax,0x180
0000013E  A30E01            mov [0x10e],ax
00000141  66C1E810          shr eax,byte 0x10
00000145  A21001            mov [0x110],al
00000148  88261301          mov [0x113],ah

0000014C  6631C0            xor eax,eax
0000014F  8CD8              mov ax,ds
00000151  66C1E004          shl eax,byte 0x4
00000155  660504010000      add eax,0x104
0000015B  66A31E01          mov [0x11e],eax

0000015F  0F01161C01        lgdt [0x11c]
00000164  FA                cli

00000165  E492              in al,0x92
00000167  0C02              or al,0x2
00000169  E692              out 0x92,al

0000016B  0F20C0            mov eax,cr0
0000016E  6683C801          or eax,byte 0x1
00000172  0F22C0            mov cr0,eax
=====进入保护模式
00000175  66EA000000000800  jmp dword 0x8:0x0
0000017D  000000 填充字节

=====LABEL_SEG_CODE32
00000180  66B81000          mov	ax, SelectorVideo
00000184  8EE8              mov gs,ax
00000186  BF7E07            mov di,0x77e
00000189  0000              add [bx+si],al
0000018B  B40C              mov ah,0xc
0000018D  B050              mov al,0x50
0000018F  65668907          mov [gs:bx],eax
00000193  EBFE              jmp short 0x193       死循环
