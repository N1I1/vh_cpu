import re

# 初始化32个寄存器
registers = {f'x{i}': '0x0000000000000000' for i in range(32)}

# 设置跳过的指令数和需要删除的最后无效指令数
skip_initial = 1
skip_final = 0
executed_lines = []  # 存储有效的日志行

def process_log_line(line):
    # 使用正则表达式提取 pc, 指令和可能的寄存器修改
    match_with_reg = re.match(r'.*0x([0-9a-fA-F]+)\s+\((0x[0-9a-fA-F]+)\)\s+x(\d+)\s+(0x[0-9a-fA-F]+)', line)
    match_nop = re.match(r'.*0x([0-9a-fA-F]+)\s+\((0x[0-9a-fA-F]+)\)', line)
    
    if match_with_reg:  # 如果匹配到了带有寄存器修改的指令
        pc, instr, reg_num, reg_val = match_with_reg.groups()
        reg_num = int(reg_num)
        registers[f'x{reg_num}'] = reg_val
        return f'0x{pc} ({instr})'
    elif match_nop:  # 如果匹配到了没有寄存器修改的nop指令
        pc, instr = match_nop.groups()
        return f'0x{pc} ({instr})'
    
    return None

def output_registers():
    reg_values = []
    for i in range(0, 32, 4):
        line = ' '.join([f'x{j}:{registers[f"x{j}"]}' for j in range(i, i + 4)])
        reg_values.append(line)
    return '\n'.join(reg_values)

# 读取log文件并处理
with open('build/spike.log', 'r') as f:
    for line in f:
        result = process_log_line(line)
        if result:
            executed_lines.append((result, output_registers()))

# 删除开头的特殊指令和最后的无效指令
executed_lines = executed_lines[skip_initial:len(executed_lines) - skip_final]

# 输出处理后的结果
with open('build/format_spike.log', 'w') as f:
    for result, registers_output in executed_lines:
        f.write(f'{result}\n{registers_output}\n\n')
