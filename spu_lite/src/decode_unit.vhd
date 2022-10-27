library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity decode_unit is
port(
    instruction : in  std_logic_vector(0 to 31);
    RegWr       : out std_logic;
    RegDst      : out std_logic_vector(0 to 6);
    Latency     : out std_logic_vector(0 to 2);
    Unit        : out std_logic_vector(0 to 2);
    Imm         : out std_logic_vector(0 to 17);
    op_SFU1     : out std_logic_vector(0 to 4);
    op_SFU2     : out std_logic_vector(0 to 2);
    op_SPU      : out std_logic_vector(0 to 3);
    op_BU       : out std_logic_vector(0 to 1);
    op_BRU      : out std_logic_vector(0 to 2);
    op_LSU      : out std_logic_vector(0 to 3);
    op_PU       : out std_logic_vector(0 to 1);
    RA          : out std_logic_vector(0 to 6);
    RA_rd       : out std_logic;
    RB          : out std_logic_vector(0 to 6);
    RB_rd       : out std_logic;
    RC          : out std_logic_vector(0 to 6);
    RC_rd       : out std_logic;
    stop        : out std_logic
);
end entity;

architecture rtl of decode_unit is

    signal Latency_i : natural range 0 to 7;
    signal Unit_i : unit_t;
    signal op_SFU1_i : simple_fixed_unit1_op_t;
    signal op_SFU2_i : simple_fixed_unit2_op_t;
    signal op_SPU_i : single_precision_unit_op_t;
    signal op_BU_i : byte_unit_op_t;
    signal op_BRU_i : branch_unit_op_t;
    signal op_LSU_i : local_store_unit_op_t;
    signal op_PU_i : permute_unit_op_t;

begin

    Latency <= std_logic_vector(to_unsigned(Latency_i, 3));
    Unit <= std_logic_vector(to_unsigned(unit_t'pos(Unit_i), 3));
    op_SFU1 <= std_logic_vector(to_unsigned(simple_fixed_unit1_op_t'pos(op_SFU1_i), 5));
    op_SFU2 <= std_logic_vector(to_unsigned(simple_fixed_unit2_op_t'pos(op_SFU2_i), 3));
    op_SPU <= std_logic_vector(to_unsigned(single_precision_unit_op_t'pos(op_SPU_i), 4));
    op_BU <= std_logic_vector(to_unsigned(byte_unit_op_t'pos(op_BU_i), 2));
    op_BRU <= std_logic_vector(to_unsigned(branch_unit_op_t'pos(op_BRU_i), 3));
    op_LSU <= std_logic_vector(to_unsigned(local_store_unit_op_t'pos(op_LSU_i), 4));
    op_PU <= std_logic_vector(to_unsigned(permute_unit_op_t'pos(op_PU_i), 2));

    process(all)
    begin
        -- Default values
        Latency_i <= 0;
        Unit_i <= unit_t'val(0);
        op_SFU1_i <= simple_fixed_unit1_op_t'val(0);
        op_SFU2_i <= simple_fixed_unit2_op_t'val(0);
        op_SPU_i <= single_precision_unit_op_t'val(0);
        op_BU_i <= byte_unit_op_t'val(0);
        op_BRU_i <= branch_unit_op_t'val(0);
        op_LSU_i <= local_store_unit_op_t'val(0);
        op_PU_i <= permute_unit_op_t'val(0);
        RegDst <= instruction(25 to 31);
        RA <= instruction(18 to 24);
        RB <= instruction(11 to 17);
        RC <= instruction(25 to 31);
        Imm <= (others => '0');
        RegWr <= '0';
        RA_rd <= '0';
        RB_rd <= '0';
        RC_rd <= '0';
        stop <= '0';
        -- Decode
        if instruction(0 to 3) = "1110" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 6;
            op_SPU_i <= OP_FLOATING_MULTIPLY_AND_ADD;
            RegDst <= instruction(4 to 10);
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
            RC_rd <= '1';
        elsif instruction(0 to 6) = "0100001" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_IMMEDIATE_LOAD_ADDRESS;
            Imm <= instruction(7 to 24);
            RegWr <= '1';
        elsif instruction(0 to 7) = "00011101" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_ADD_HALFWORD_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "00011100" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_ADD_WORD_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "00001101" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_SUBTRACT_FROM_HALFWORD_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "00001100" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_SUBTRACT_FROM_WORD_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "01111100" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_EQUAL_WORD_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "01001100" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_GREATER_THAN_WORD_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "01011100" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "01110100" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 7;
            op_SPU_i <= OP_MULTIPLY_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "01110101" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 7;
            op_SPU_i <= OP_MULTIPLY_UNSIGNED_IMMEDIATE;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "00100100" then
            Unit_i <= UNIT_LOCAL_STORE;
            Latency_i <= 6;
            op_LSU_i <= OP_STORE_QUADWORD_D;
            Imm <= 8x"0" & instruction(8 to 17);
            RA_rd <= '1';
            RC_rd <= '1';
        elsif instruction(0 to 7) = "00110100" then
            Unit_i <= UNIT_LOCAL_STORE;
            Latency_i <= 6;
            op_LSU_i <= OP_LOAD_QUADWORD_D;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 7) = "10100100" then
            Unit_i <= UNIT_LOCAL_STORE;
            Latency_i <= 6;
            op_LSU_i <= OP_STORE_CONDITIONAL;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
            RC_rd <= '1';
        elsif instruction(0 to 7) = "10110100" then
            Unit_i <= UNIT_LOCAL_STORE;
            Latency_i <= 6;
            op_LSU_i <= OP_LOAD_LINKED;
            Imm <= 8x"0" & instruction(8 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 8) = "010000011" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_IMMEDIATE_LOAD_HALFWORD;
            Imm <= 2x"0" & instruction(9 to 24);
            RegWr <= '1';
        elsif instruction(0 to 8) = "010000010" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_IMMEDIATE_LOAD_HALFWORD_UPPER;
            Imm <= 2x"0" & instruction(9 to 24);
            RegWr <= '1';
        elsif instruction(0 to 8) = "010000001" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_IMMEDIATE_LOAD_WORD;
            Imm <= 2x"0" & instruction(9 to 24);
            RegWr <= '1';
        elsif instruction(0 to 8) = "001100100" then
            Unit_i <= UNIT_BRANCH;
            Latency_i <= 1;
            op_BRU_i <= OP_BRANCH_RELATIVE;
            Imm <= 2x"0" & instruction(9 to 24);
        elsif instruction(0 to 8) = "001100000" then
            Unit_i <= UNIT_BRANCH;
            Latency_i <= 1;
            op_BRU_i <= OP_BRANCH_ABSOLUTE;
            Imm <= 2x"0" & instruction(9 to 24);
        elsif instruction(0 to 8) = "001000010" then
            Unit_i <= UNIT_BRANCH;
            Latency_i <= 1;
            op_BRU_i <= OP_BRANCH_IF_NOT_ZERO_WORD;
            Imm <= 2x"0" & instruction(9 to 24);
            RC_rd <= '1';
        elsif instruction(0 to 8) = "001000000" then
            Unit_i <= UNIT_BRANCH;
            Latency_i <= 1;
            op_BRU_i <= OP_BRANCH_IF_ZERO_WORD;
            Imm <= 2x"0" & instruction(9 to 24);
            RC_rd <= '1';
        elsif instruction(0 to 8) = "001000110" then
            Unit_i <= UNIT_BRANCH;
            Latency_i <= 1;
            op_BRU_i <= OP_BRANCH_IF_NOT_ZERO_HALFWORD;
            Imm <= 2x"0" & instruction(9 to 24);
            RC_rd <= '1';
        elsif instruction(0 to 8) = "001000100" then
            Unit_i <= UNIT_BRANCH;
            Latency_i <= 1;
            op_BRU_i <= OP_BRANCH_IF_ZERO_HALFWORD;
            Imm <= 2x"0" & instruction(9 to 24);
            RC_rd <= '1';
        elsif instruction(0 to 8) = "001000001" then
            Unit_i <= UNIT_LOCAL_STORE;
            Latency_i <= 6;
            op_LSU_i <= OP_STORE_QUADWORD_A;
            Imm <= 2x"0" & instruction(9 to 24);
            RC_rd <= '1';
        elsif instruction(0 to 8) = "001100001" then
            Unit_i <= UNIT_LOCAL_STORE;
            Latency_i <= 6;
            op_LSU_i <= OP_LOAD_QUADWORD_A;
            Imm <= 2x"0" & instruction(9 to 24);
            RegWr <= '1';
        elsif instruction(0 to 9) = "0111011010" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 6;
            op_SPU_i <= OP_CONVERT_SIGNED_INTEGER_TO_FLOATING;
            Imm <= 10x"0" & instruction(10 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 9) = "0111011000" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 6;
            op_SPU_i <= OP_CONVERT_FLOATING_TO_SIGNED_INTEGER;
            Imm <= 10x"0" & instruction(10 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00001111111" then
            Unit_i <= UNIT_SIMPLE_FIXED2;
            Latency_i <= 4;
            op_SFU2_i <= OP_SHIFT_LEFT_HALFWORD_IMMEDIATE;
            Imm <= 11x"0" & instruction(11 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00001111011" then
            Unit_i <= UNIT_SIMPLE_FIXED2;
            Latency_i <= 4;
            op_SFU2_i <= OP_SHIFT_LEFT_WORD_IMMEDIATE;
            Imm <= 11x"0" & instruction(11 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00001111100" then
            Unit_i <= UNIT_SIMPLE_FIXED2;
            Latency_i <= 4;
            op_SFU2_i <= OP_ROTATE_HALFWORD_IMMEDIATE;
            Imm <= 11x"0" & instruction(11 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00001111000" then
            Unit_i <= UNIT_SIMPLE_FIXED2;
            Latency_i <= 4;
            op_SFU2_i <= OP_ROTATE_WORD_IMMEDIATE;
            Imm <= 11x"0" & instruction(11 to 17);
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00011001000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_ADD_HALFWORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00011000000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_ADD_WORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001001000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_SUBTRACT_FROM_HALFWORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001000000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_SUBTRACT_FROM_WORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01010100101" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COUNT_LEADING_ZEROS;
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00011000001" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_AND;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001000001" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_OR;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01001000001" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_XOR;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00011001001" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_NAND;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001001001" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_NOR;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01111001000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_EQUAL_HALFWORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01111000000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_EQUAL_WORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01001001000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_GREATER_THAN_HALFWORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01001000000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_GREATER_THAN_WORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01011001000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_LOGICAL_GREATER_THAN_HALFWORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01011000000" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
            Latency_i <= 2;
            op_SFU1_i <= OP_COMPARE_LOGICAL_GREATER_THAN_WORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001011111" then
            Unit_i <= UNIT_SIMPLE_FIXED2;
            Latency_i <= 4;
            op_SFU2_i <= OP_SHIFT_LEFT_HALFWORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001011011" then
            Unit_i <= UNIT_SIMPLE_FIXED2;
            Latency_i <= 4;
            op_SFU2_i <= OP_SHIFT_LEFT_WORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001011100" then
            Unit_i <= UNIT_SIMPLE_FIXED2;
            Latency_i <= 4;
            op_SFU2_i <= OP_ROTATE_HALFWORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001011000" then
            Unit_i <= UNIT_SIMPLE_FIXED2;
            Latency_i <= 4;
            op_SFU2_i <= OP_ROTATE_WORD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01111000100" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 7;
            op_SPU_i <= OP_MULTIPLY;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01111001100" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 7;
            op_SPU_i <= OP_MULTIPLY_UNSIGNED;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01111000010" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 6;
            op_SPU_i <= OP_FLOATING_COMPARE_EQUAL;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01011000010" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 6;
            op_SPU_i <= OP_FLOATING_COMPARE_GREATER_THAN;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01011000100" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 6;
            op_SPU_i <= OP_FLOATING_ADD;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01011000101" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 6;
            op_SPU_i <= OP_FLOATING_SUBTRACT;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01011000110" then
            Unit_i <= UNIT_SINGLE_PRECISION;
            Latency_i <= 6;
            op_SPU_i <= OP_FLOATING_MULTIPLY;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01010110100" then
            Unit_i <= UNIT_BYTE;
            Latency_i <= 4;
            op_BU_i <= OP_COUNT_ONES_IN_BYTES;
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00011010011" then
            Unit_i <= UNIT_BYTE;
            Latency_i <= 4;
            op_BU_i <= OP_AVERAGE_BYTES;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00001010011" then
            Unit_i <= UNIT_BYTE;
            Latency_i <= 4;
            op_BU_i <= OP_ABSOLUTE_DIFFERENCE_OF_BYTES;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01001010011" then
            Unit_i <= UNIT_BYTE;
            Latency_i <= 4;
            op_BU_i <= OP_SUM_BYTES_INTO_HALFWORDS;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "01000000001" then
            Unit_i <= UNIT_SIMPLE_FIXED1;
        elsif instruction(0 to 10) = "00110110010" then
            Unit_i <= UNIT_PERMUTE;
            Latency_i <= 4;
            op_PU_i <= OP_GATHER_BITS_FROM_BYTES;
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00110110001" then
            Unit_i <= UNIT_PERMUTE;
            Latency_i <= 4;
            op_PU_i <= OP_GATHER_BITS_FROM_HALFWORDS;
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00110110000" then
            Unit_i <= UNIT_PERMUTE;
            Latency_i <= 4;
            op_PU_i <= OP_GATHER_BITS_FROM_WORDS;
            RegWr <= '1';
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00110101000" then
            Unit_i <= UNIT_BRANCH;
            Latency_i <= 1;
            op_BRU_i <= OP_BRANCH_INDIRECT;
            RA_rd <= '1';
        elsif instruction(0 to 10) = "00101000100" then
            Unit_i <= UNIT_LOCAL_STORE;
            Latency_i <= 6;
            op_LSU_i <= OP_STORE_QUADWORD_X;
            RA_rd <= '1';
            RB_rd <= '1';
            RC_rd <= '1';
        elsif instruction(0 to 10) = "00111000100" then
            Unit_i <= UNIT_LOCAL_STORE;
            Latency_i <= 6;
            op_LSU_i <= OP_LOAD_QUADWORD_X;
            RegWr <= '1';
            RA_rd <= '1';
            RB_rd <= '1';
        elsif instruction(0 to 10) = "00000000001" then
            Unit_i <= UNIT_BRANCH;
        elsif instruction(0 to 10) = "00000000000" then
            stop <= '1';
        end if;
    end process;

end architecture;