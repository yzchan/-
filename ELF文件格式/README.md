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