OUTPUT_ARCH(riscv)

ENTRY(_start)

SECTIONS
{
    . = 0x3000;

    .text :
    {
        *(.text)   /* 包含所有 .text 段，即代码段 */
    }

    .rodata :
    {
        *(.rodata) /* 只读数据段（常量等） */
    }

    .data :
    {
        *(.data)   /* 可读写数据段 */
    }

    .bss :
    {
        *(.bss)    /* 未初始化的数据段，通常为0 */
    }

    .tohost :
    {
        *(.tohost)
    }
    
    .fromhost :
    {
        *(.fromhost)
    }

}
