.section .text
.globl main
main:
    # --- 加载立即数 ---
    #li      t0, 15       # 将 15 加载到寄存器 t0
    li      t1, -5       # 将 -5 加载到寄存器 t1
    li      t2, 0xF0F0   # 将 0xF0F0 加载到寄存器 t2
    
    # --- 基本算术运算 ---
    add     t3, t0, t1   # t3 = t0 + t1
    sub     t4, t0, t1   # t4 = t0 - t1

    
    # --- 逻辑运算 ---
    and     t3, t0, t2   # t3 = t0 & t2 (按位与)
    or      t4, t0, t2   # t4 = t0 | t2 (按位或)
    xor     t5, t0, t2   # t5 = t0 ^ t2 (按位异或)
    not     t6, t0       # t6 = ~t0 (按位取反)

    andi    t3, t6, 100
    ori     t3, t6, 100
    xori    t3, t6, 100

    # --- 移位操作 ---
    sll     t1, t0, 2    # t1 = t0 << 2 (逻辑左移)
    srl     t2, t0, 2    # t2 = t0 >> 2 (逻辑右移)
    sra     t3, t0, 2    # t3 = t0 >>> 2 (算术右移)

    # --- 条件比较 ---
    slt     t4, t0, t1   # t4 = (t0 < t1) ? 1 : 0 (有符号比较)
    sltu    t5, t0, t1   # t5 = (t0 < t1 无符号) ? 1 : 0
    beq     t0, t1, label_equal  # 如果 t0 == t1 则跳转
    bne     t0, t1, label_not_equal # 如果 t0 != t1 则跳转

label_equal:
    #li      t6, 100      # 如果相等，设置 t6 = 100

label_not_equal:
    #li      t6, 200      # 如果不相等，设置 t6 = 200

    ## --- 内存访问指令 ---
    #lw      t1, 0(t0)    # 从内存中加载一个字

	# --- AUI
	auipc   t0, 100
	lui     t0, 200

	ret
