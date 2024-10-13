import re
from capstone import *

md = Cs(CS_ARCH_RISCV, CS_MODE_RISCV64)

def read_log(log_file):
    pc_instr_regs_info = []
    registers = {f'x{i}': '0x0000000000000000' for i in range(32)}

    with open(log_file, 'r') as f:
        lines = f.readlines()

        for i in range(0, len(lines), 10):  # 每个块包含10行
            # 检查是否有足够的行
            if i + 9 >= len(lines):
                break

            # 提取PC和指令
            pc_instr_line = lines[i].strip()
            pc, instr = pc_instr_line.split(' ')
            instr = instr[1:-1]  # 去掉括号

            # 清空寄存器状态
            registers = {f'x{i}': '0x0000000000000000' for i in range(32)}

            # 提取寄存器值
            for j in range(1, 9):  # 从第1行到第8行提取寄存器
                reg_line = lines[i + j].strip()
                if reg_line:  # 确保该行不为空
                    reg_entries = reg_line.split()
                    for reg_info in reg_entries:
                        if ':' in reg_info:  # 确保格式正确
                            reg, val = reg_info.split(':')
                            registers[reg] = val

            # 将PC、指令和寄存器状态存储到列表中
            pc_instr_regs_info.append((pc, instr, registers.copy()))

    for info in pc_instr_regs_info:
        assert(len(info) == 3)
    return pc_instr_regs_info

def compare_logs(log_info_correct, log_info_res, start=0, end=0):
    differences = []
    corrects = []
    correct_count = 0
    for i, (pc, instr, regs) in enumerate(log_info_res):
        if i < start or (end != 0 and i >= end):
            continue

        pc_correct, instr_correct, regs_correct = log_info_correct[i]
        if pc != pc_correct or instr != instr_correct or (not compare_regs(regs, regs_correct)):
            differences.append((i, (pc_correct, instr_correct, regs_correct), (pc, instr, regs)))
        else:
            correct_count += 1
            corrects.append((pc, instr))

    save_correct_instr_type('tests/build/correct_instr.log', corrects)
    return differences, correct_count

def compare_regs(regs1, regs2):
    for reg in regs1:
        if regs1[reg] != regs2[reg]:
            regs1[reg] = "/" + regs1[reg] + "\\"
            return False
    return True

def output_comparison_results(differences, correct_count, output_file):
    with open(output_file, 'w') as f:
        f.write(f'Correct: {correct_count}\n')
        f.write(f'Incorrect: {len(differences)}\n\n')
        for i, correct, res in differences:
            f.write(f'Instruction {i}:\n')
            f.write(f'Correct:\n{info_to_str(correct)}\n')
            f.write(f'Result:\n{info_to_str(res)}\n\n')

def disassemble_instr(instr: str, pc: str):
    byte_instr = instr[-2:] + instr[-4:-2] + instr[-6:-4] + instr[-8:-6]
    byte_instr = bytes.fromhex(byte_instr)
    res = ''
    for i in md.disasm(byte_instr, int(pc[2:], 16)):
        res += f'0x{i.address:016x}:\t({instr})\t{i.mnemonic}\t{i.op_str}\n'
    return res

def info_to_str(info):
    pc, instr, regs = info
    res = disassemble_instr(instr, pc)
    
    for i, reg in enumerate(regs):
        res += f'{reg}: {regs[reg]}'
        if i % 4 == 3:
            res += '\n'
        else:
            res += ' '
    return res

def delete_instr(origin_file_path, modified_file_path, num):
    uni_line_len = 9
    with open(origin_file_path, 'r') as file:
        lines = file.readlines()
        lines = lines[num*uni_line_len:]
    with open(modified_file_path, 'w') as file:
        file.writelines(lines[num:])

def save_correct_instr_type(saved_file_path, corrects):
    with open(saved_file_path, 'w') as file:
        for pc, instr in corrects:
            file.write(disassemble_instr(instr, pc))

delete_instr_num = 3
# Example usage
correct_log = 'tests/build/format_spike.log'
my_log = 'tests/build/res.log'
format_res_log = 'tests/build/format_res.log'
delete_instr(my_log, format_res_log, delete_instr_num)
correct_info = read_log(correct_log)
res_info = read_log(format_res_log)
differences, correct_count = compare_logs(correct_info, res_info, start=2, end=36)
output_comparison_results(differences, correct_count, 'tests/build/diff.log')
