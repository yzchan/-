ELF文件格式
---

> [Linux C编程一站式学习](https://akaedu.github.io/book/)

#### ELF的历史
ELF是Linux的主要可执行文件格式。而Windows上的可执行文件格式为PE，PE文件格式事实上与ELF同根同源，它们都是由COFF格式发展而来。macOS使用的可执行文件格式为MAC-O。


#### 用到的命令

- readelf
- hexdump
- objdump
- strip
- file
- size
- nm


#### 示例代码

```s
# max.s
#PURPOSE: This program finds the maximum number of aset of data items.
##VARIABLES: The registers have the following uses:
## %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
## The following memory locations are used:
## data_items - contains the item data. A 0 is used
# to terminate the data

.section .data
        data_items: .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text
.globl _start
_start:
        movl $0, %edi
        movl data_items(,%edi,4), %eax
        movl %eax, %ebx
start_loop:
        cmpl $0, %eax
        je loop_exit
        incl %edi
        movl data_items(,%edi,4), %eax
        cmpl %ebx, %eax
        jle start_loop
        movl %eax, %ebx
        jmp start_loop
loop_exit:
        movl $1, %eax
        int $0x80
```

用汇编器生成目标文件
```bash
as max.s -o max.o
```

用链接器生成可执行文件
```bash
ld max.o -o max
```

##### ELF Header

通过`readelf -h max.o`读取ELF Header信息

```text
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              REL (Relocatable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x0
  Start of program headers:          0 (bytes into file)
  Start of section headers:          504 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           0 (bytes)
  Number of program headers:         0
  Size of section headers:           64 (bytes)
  Number of section headers:         8
  Section header string table index: 7
```

Size of this header指示了ELF Header信息一共占据64字节的空间，再用`hexdump -Cv -n64 -s0 max.o`从头开始把ELF头信息全部读出来。
```
00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
00000010  01 00 3e 00 01 00 00 00  00 00 00 00 00 00 00 00  |..>.............|
00000020  00 00 00 00 00 00 00 00  f8 01 00 00 00 00 00 00  |................|
00000030  00 00 00 00 40 00 00 00  00 00 40 00 08 00 07 00  |....@.....@.....|
```


> CentOS Linux release 7.8.2003 (Core) ELF头文件路径：`/usr/include/elf.h`

读取ELF Header的定义
```c
typedef struct
{
  unsigned char	e_ident[EI_NIDENT];	/* Magic number and other info */
  Elf64_Half	e_type;			/* Object file type */
  Elf64_Half	e_machine;		/* Architecture */
  Elf64_Word	e_version;		/* Object file version */
  Elf64_Addr	e_entry;		/* Entry point virtual address */
  Elf64_Off	e_phoff;		/* Program header table file offset */
  Elf64_Off	e_shoff;		/* Section header table file offset */
  Elf64_Word	e_flags;		/* Processor-specific flags */
  Elf64_Half	e_ehsize;		/* ELF header size in bytes */
  Elf64_Half	e_phentsize;		/* Program header table entry size */
  Elf64_Half	e_phnum;		/* Program header table entry count */
  Elf64_Half	e_shentsize;		/* Section header table entry size */
  Elf64_Half	e_shnum;		/* Section header table entry count */
  Elf64_Half	e_shstrndx;		/* Section header string table index */
} Elf64_Ehdr;
```

#### ELF Header分析

max.o目标文件hexdump出来的信息第一行`00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|`与readelf结果中的Magic完全一致。

前面的`7f 45 4c 46`是类型魔数，指示了Linux文件类型是ELF文件，这是Linux一种常用的方法。45 4c 46其实就是ELF3个字母的ASCII码。
看一下ELF头文件定义
```c
#define EI_MAG0		0		/* File identification byte 0 index */
#define ELFMAG0		0x7f		/* Magic number byte 0 */

#define EI_MAG1		1		/* File identification byte 1 index */
#define ELFMAG1		'E'		/* Magic number byte 1 */

#define EI_MAG2		2		/* File identification byte 2 index */
#define ELFMAG2		'L'		/* Magic number byte 2 */

#define EI_MAG3		3		/* File identification byte 3 index */
#define ELFMAG3		'F'		/* Magic number byte 3 */

/* Conglomeration of the identification bytes, for easy testing as a word.  */
#define	ELFMAG		"\177ELF"
#define	SELFMAG		4
```


第5位02表示是64位体系的文件
```c
#define EI_CLASS	4		/* File class byte index */
#define ELFCLASSNONE	0		/* Invalid class */
#define ELFCLASS32	1		/* 32-bit objects */
#define ELFCLASS64	2		/* 64-bit objects */
#define ELFCLASSNUM	3
```

第6位01表示2补码小端序
```c
#define EI_DATA		5		/* Data encoding byte index */
#define ELFDATANONE	0		/* Invalid data encoding */
#define ELFDATA2LSB	1		/* 2's complement, little endian */
#define ELFDATA2MSB	2		/* 2's complement, big endian */
#define ELFDATANUM	3
```

第7位01表示ELF版本，固定为01
```c
#define EI_VERSION	6		/* File version byte index */
							/* Value must be EV_CURRENT */
```

第8位00表示操作系统为UNIX System V ABI
```c
#define EI_OSABI	7		/* OS ABI identification */
#define ELFOSABI_NONE		0	/* UNIX System V ABI */
#define ELFOSABI_SYSV		0	/* Alias.  */
#define ELFOSABI_HPUX		1	/* HP-UX */
#define ELFOSABI_NETBSD		2	/* NetBSD.  */
#define ELFOSABI_GNU		3	/* Object uses GNU ELF extensions.  */
#define ELFOSABI_LINUX		ELFOSABI_GNU /* Compatibility alias.  */
#define ELFOSABI_SOLARIS	6	/* Sun Solaris.  */
#define ELFOSABI_AIX		7	/* IBM AIX.  */
#define ELFOSABI_IRIX		8	/* SGI Irix.  */
#define ELFOSABI_FREEBSD	9	/* FreeBSD.  */
#define ELFOSABI_TRU64		10	/* Compaq TRU64 UNIX.  */
#define ELFOSABI_MODESTO	11	/* Novell Modesto.  */
#define ELFOSABI_OPENBSD	12	/* OpenBSD.  */
#define ELFOSABI_ARM_AEABI	64	/* ARM EABI */
#define ELFOSABI_ARM		97	/* ARM */
#define ELFOSABI_STANDALONE	255	/* Standalone (embedded) application */
```

第9位表示ABI version
```c
#define EI_ABIVERSION	8		/* ABI version */
```

后面几位都是填充字符，
```c
#define EI_PAD		9		/* Byte index of padding bytes */
```


##### 然后来看section header节头
```text
  Start of section headers:          504 (bytes into file)
  Size of section headers:           64 (bytes)
  Number of section headers:         8
```
节头从504字节开始，共8个节头，每个节头占据64字节空间

readelf -S max.o

```text
There are 8 section headers, starting at offset 0x1f8:

Section Headers:
  [Nr] Name              Type             Address           Offset    Size              EntSize          Flags     Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000  0000000000000000  0000000000000000           0     0     0
  [ 1] .text             PROGBITS         0000000000000000  00000040  000000000000002d  0000000000000000  AX       0     0     1
  [ 2] .rela.text        RELA             0000000000000000  00000190  0000000000000030  0000000000000018   I       5     1     8
  [ 3] .data             PROGBITS         0000000000000000  0000006d  0000000000000038  0000000000000000  WA       0     0     1
  [ 4] .bss              NOBITS           0000000000000000  000000a5  0000000000000000  0000000000000000  WA       0     0     1
  [ 5] .symtab           SYMTAB           0000000000000000  000000a8  00000000000000c0  0000000000000018           6     7     8
  [ 6] .strtab           STRTAB           0000000000000000  00000168  0000000000000028  0000000000000000           0     0     1
  [ 7] .shstrtab         STRTAB           0000000000000000  000001c0  0000000000000031  0000000000000000           0     0     1
```

第0段全部是0填充的，不知道有什么意义。

先来看[ 1] .text `hexdump -Cv -n64 -s568 max.o`
```text
00000238  20 00 00 00 01 00 00 00  06 00 00 00 00 00 00 00  | ...............|
00000248  00 00 00 00 00 00 00 00  40 00 00 00 00 00 00 00  |........@.......|
00000258  2d 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |-...............|
00000268  01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
```

看一下Sections Header的定义
```c
typedef struct
{
  Elf64_Word	sh_name;		/* Section name (string tbl index) */
  Elf64_Word	sh_type;		/* Section type */
  Elf64_Xword	sh_flags;		/* Section flags */
  Elf64_Addr	sh_addr;		/* Section virtual addr at execution */
  Elf64_Off	sh_offset;		/* Section file offset */
  Elf64_Xword	sh_size;		/* Section size in bytes */
  Elf64_Word	sh_link;		/* Link to another section */
  Elf64_Word	sh_info;		/* Additional section information */
  Elf64_Xword	sh_addralign;		/* Section alignment */
  Elf64_Xword	sh_entsize;		/* Entry size if section holds table */
} Elf64_Shdr;
```

可见代码段占据从0x40开始长度为0x2d的空间，用hexdump读出来看下`hexdump -Cv -n0x2d -s0x40 max.o`
```text
00000040  bf 00 00 00 00 67 8b 04  bd 00 00 00 00 89 c3 83  |.....g..........|
00000050  f8 00 74 12 ff c7 67 8b  04 bd 00 00 00 00 39 d8  |..t...g.......9.|
00000060  7e ed 89 c3 eb e9 b8 01  00 00 00 cd 80           |~............|
```

再反汇编一下max.o目标文件 `objdump -d max.o`
```text
max.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <_start>:
   0:   bf 00 00 00 00          mov    $0x0,%edi
   5:   67 8b 04 bd 00 00 00    mov    0x0(,%edi,4),%eax
   c:   00 
   d:   89 c3                   mov    %eax,%ebx

000000000000000f <start_loop>:
   f:   83 f8 00                cmp    $0x0,%eax
  12:   74 12                   je     26 <loop_exit>
  14:   ff c7                   inc    %edi
  16:   67 8b 04 bd 00 00 00    mov    0x0(,%edi,4),%eax
  1d:   00 
  1e:   39 d8                   cmp    %ebx,%eax
  20:   7e ed                   jle    f <start_loop>
  22:   89 c3                   mov    %eax,%ebx
  24:   eb e9                   jmp    f <start_loop>

0000000000000026 <loop_exit>:
  26:   b8 01 00 00 00          mov    $0x1,%eax
  2b:   cd 80                   int    $0x80
```

对比可见是完全一样，将源代码汇编之后的二进制指令全部放入可执行文件ELF中。

再看[ 3] .data `hexdump -Cv -n0x38 -s0x6d max.o`
```
0000006d  03 00 00 00 43 00 00 00  22 00 00 00 de 00 00 00  |....C...".......|
0000007d  2d 00 00 00 4b 00 00 00  36 00 00 00 22 00 00 00  |-...K...6..."...|
0000008d  2c 00 00 00 21 00 00 00  16 00 00 00 0b 00 00 00  |,...!...........|
0000009d  42 00 00 00 00 00 00 00                           |B.......|
```

```s
.section .data
	data_items: .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
```

跟源代码中定义的数据段也完全一致

其他段都是编译器加上去的section:

- [ 2] .rela.text 是给链接器做重定位用的
- [ 4] .bss 用来存放程序中未初始化的或者初始值为0的全局变量的一块内存区域。属于静态内存分配。BSS全称Block Started by Symbol
- [ 5] .symtab 符号表
- [ 6] .strtab 程序中用到的符号的名字，每个名字都是以Null结尾的字符串。
- [ 7] .shstrtab 各Section的名称表