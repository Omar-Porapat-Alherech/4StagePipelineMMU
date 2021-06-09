R3_instructions_dict = {
    "NOP": "0000",
    "AU": "0001",
    "ABSDB": "0010",
    "AHU": "0011",
    "AHS": "0100",
    "AND": "0101",
    "BCW": "0110",
    "MAXWS": "0111",
    "MINWS": "01000",
    "MLHU": "1001",
    "MLHCU": "1010",
    "OR": "1011",
    "PCNTW": "1100",
    "ROTW": "1101",
    "SFHS": "1110",
    "SFW": "1111"
}
R4_instructions_dict = {}

""" 
This portion of the projects serves as the Assembler. The goal of this file is to convert an assembly file
into its respective binary format for the Instruction Buffer. 
"""


def main():
    # This will have to be refactored to your respective directory
    input_file = open("asm_input.txt", "r")
    # Read Input file line by line
    input_lines = input_file.readlines()
    # We are going to determine the instruction format using the number of register inputs
    # i.e 3 Instructions = R3 Format, 4 Instructions = R4 format
    file = open("Atrelis.txt", "a")
    for line_x in input_lines:
        # Figure out how many register inputs are present
        # Alternatively we can count the number of '\$' symbols
        instruction_format = num_instances(line_x, '$')
        print("=====================================================")
        print("Command %s" % line_x.strip())
        print("NUM_INSTANCES %s" % instruction_format)
        command_divisions = string_cleanup(line_x.strip(), '$').split(",")
        if instruction_format == 1:
            bit_stream = li_instruction(command_divisions)
            file.write(bit_stream + "\n")
        elif instruction_format == 4:
            bit_stream = r4_instructions(command_divisions)
            file.write(bit_stream + "\n")
        elif instruction_format == 3:
            bit_stream = r3_instructions(command_divisions)
            file.write(bit_stream + "\n")
        elif command_divisions[0].__contains__("nop"):
            file.write("1100000000000000000000000" + "\n")
        else:
            raise AssertionError


def li_instruction(command_divisions):
    """
    The split command line will result in a few variables
    0 for the most part will be unused
    1 will be the load index
    2 will be the 16 bit immediate
    3 will be the register rd
    """
    # Splitting first division again looking for the initial input command
    # i.e Li 10 -> split into LI and 10
    # INSTRUCTION TYPE
    instruction_type = '0'
    print("Bit 24 === %s" % instruction_type)
    # LOAD INDEX
    load_index_int = command_divisions[0].split(" ")[1]
    load_index_binary = pad_left(convert_binary(load_index_int), 3)
    print("Bit 23-21 %s === %s" % (load_index_int, load_index_binary))
    # IMMEDIATE
    immediate_val_int = command_divisions[1]
    immediate_val_binary = pad_left(convert_binary(immediate_val_int), 16)
    print("Bit 20-5 %s === %s" % (immediate_val_int, immediate_val_binary))
    # REGISTER RD
    register_num_int = command_divisions[2]
    register_num_binary = pad_left(convert_binary(register_num_int), 5)
    print("Bit 5-0 %s === %s" % (register_num_int, register_num_binary))
    return instruction_type + load_index_binary + immediate_val_binary + register_num_binary


def r3_instructions(command_divisions):
    """
            The split command line will result in a few variables
            0 for the most part will be unused
            0[1] will be the long/int subtract/add high/low
            1 will be rs2
            2 will be rs1
            0[1] will be rd
        """
    instruction_type = '11'
    print("Bit 24-23 === %s" % instruction_type)
    # Opcode Table
    opcode_val = pad_left(R3_instructions_dict[command_divisions[0].split(" ")[0]], 8)
    print("Bit 22-15  === %s" % opcode_val)
    # rs2
    rs2_int = command_divisions[1]
    rs2_binary = pad_left(convert_binary(rs2_int), 5)
    print("Bit 14-10 %s === %s" % (rs2_int, rs2_binary))
    # rs1
    rs1_int = command_divisions[2]
    rs1_binary = pad_left(convert_binary(rs1_int), 5)
    print("Bit 9-5 %s === %s" % (rs1_int, rs1_binary))
    # rsd
    rsd_int = command_divisions[0].split(" ")[1]
    rsd_binary = pad_left(convert_binary(rsd_int), 5)
    print("Bit 5-0 %s === %s" % (rsd_int, rsd_binary))
    return instruction_type + opcode_val + rs2_binary + rs1_binary + rsd_binary


def r4_instructions(command_divisions):
    """
        The split command line will result in a few variables
        0 for the most part will be unused
        0[1] will be the long/int subtract/add high/low
        1 will be rs3
        2 will be rs2
        3 will be rs1
        4 will be rd
    """
    instruction_type = '10'
    print("Bit 24-23 === %s" % instruction_type)
    # LONG_INT SUBTRACT/ADD HIGH/LOW BITS
    li_sa_hl_int = command_divisions[0].split(" ")[1]
    li_sa_hl_binary = pad_left(convert_binary(li_sa_hl_int), 3)
    print("Bit 22-20 %s === %s" % (li_sa_hl_int, li_sa_hl_binary))
    # rs3
    rs3_int = command_divisions[1]
    rs3_binary = pad_left(convert_binary(rs3_int), 5)
    print("Bit 19-15 %s === %s" % (rs3_int, rs3_binary))
    # rs2
    rs2_int = command_divisions[2]
    rs2_binary = pad_left(convert_binary(rs2_int), 5)
    print("Bit 14-10 %s === %s" % (rs2_int, rs2_binary))
    # rs1
    rs1_int = command_divisions[3]
    rs1_binary = pad_left(convert_binary(rs1_int), 5)
    print("Bit 9-5 %s === %s" % (rs1_int, rs1_binary))
    # rsd
    rsd_int = command_divisions[4]
    rsd_binary = pad_left(convert_binary(rsd_int), 5)
    print("Bit 5-0 %s === %s" % (rsd_int, rsd_binary))
    return instruction_type + li_sa_hl_binary + rs3_binary + rs2_binary + rs1_binary + rsd_binary


def string_cleanup(input_string, clean_up):
    return input_string.replace(clean_up, '')


def pad_left(binary_val, num_bits):
    return binary_val.rjust(num_bits, '0')


def convert_binary(int_val):
    return "{0:b}".format(int(int_val))


# We will be using this function to search for specific symbols within the line, in most cases
# this will be the '\$' symbol
def num_instances(input_string, instance_of):
    instance_counter = 0
    for char in input_string:
        if char == instance_of:
            instance_counter = instance_counter + 1
    return instance_counter


if __name__ == '__main__':
    main()
