library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity simple_fixed_unit1 is
port(
    op_sel : in  std_logic_vector(0 to 4);
    A      : in  std_logic_vector(0 to 127);
    B      : in  std_logic_vector(0 to 127);
    Imm    : in  std_logic_vector(0 to 17);
    Result : out std_logic_vector(0 to 127)
);
end entity;

architecture rtl of simple_fixed_unit1 is

function count_leading_zeros(s : std_logic_vector) return natural is
    variable r : natural := 0;
begin
    for i in s'range loop
        exit when s(i);
        r := r + 1;
    end loop;
    return r;
end function;

signal op : simple_fixed_unit1_op_t;

begin

op <= simple_fixed_unit1_op_t'val(to_integer(unsigned(op_sel)));

process(all)
begin
    case op is
    when OP_IMMEDIATE_LOAD_HALFWORD =>
        Result(0 to 15) <= Imm(2 to 17);
        Result(16 to 31) <= Imm(2 to 17);
        Result(32 to 47) <= Imm(2 to 17);
        Result(48 to 63) <= Imm(2 to 17);
        Result(64 to 79) <= Imm(2 to 17);
        Result(80 to 95) <= Imm(2 to 17);
        Result(96 to 111) <= Imm(2 to 17);
        Result(112 to 127) <= Imm(2 to 17);
    when OP_IMMEDIATE_LOAD_HALFWORD_UPPER =>
        Result(0 to 31) <= Imm(2 to 17) & (16 to 31 => '0');
        Result(32 to 63) <= Imm(2 to 17) & (16 to 31 => '0');
        Result(64 to 95) <= Imm(2 to 17) & (16 to 31 => '0');
        Result(96 to 127) <= Imm(2 to 17) & (16 to 31 => '0');
    when OP_IMMEDIATE_LOAD_WORD =>
        Result(0 to 31) <= (0 to 15 => Imm(2))&Imm(2 to 17);
        Result(32 to 63) <= (0 to 15 => Imm(2))&Imm(2 to 17);
        Result(64 to 95) <= (0 to 15 => Imm(2))&Imm(2 to 17);
        Result(96 to 127) <= (0 to 15 => Imm(2))&Imm(2 to 17);
    when OP_IMMEDIATE_LOAD_ADDRESS =>
        Result(0 to 31) <= (0 to 13 => '0')&Imm(0 to 17);
        Result(32 to 63) <= (0 to 13 => '0')&Imm(0 to 17);
        Result(64 to 95) <= (0 to 13 => '0')&Imm(0 to 17);
        Result(96 to 127) <= (0 to 13 => '0')&Imm(0 to 17);
    when OP_ADD_HALFWORD =>
        Result(0 to 15) <= std_logic_vector(signed(A(0 to 15)) + signed(B(0 to 15)));
        Result(16 to 31) <= std_logic_vector(signed(A(16 to 31)) + signed(B(16 to 31)));
        Result(32 to 47) <= std_logic_vector(signed(A(32 to 47)) + signed(B(32 to 47)));
        Result(48 to 63) <= std_logic_vector(signed(A(48 to 63)) + signed(B(48 to 63)));
        Result(64 to 79) <= std_logic_vector(signed(A(64 to 79)) + signed(B(64 to 79)));
        Result(80 to 95) <= std_logic_vector(signed(A(80 to 95)) + signed(B(80 to 95)));
        Result(96 to 111) <= std_logic_vector(signed(A(96 to 111)) + signed(B(96 to 111)));
        Result(112 to 127) <= std_logic_vector(signed(A(112 to 127)) + signed(B(112 to 127)));
    when OP_ADD_HALFWORD_IMMEDIATE =>
        Result(0 to 15) <= std_logic_vector(signed(A(0 to 15)) + signed(Imm(8 to 17)));
        Result(16 to 31) <= std_logic_vector(signed(A(16 to 31)) + signed(Imm(8 to 17)));
        Result(32 to 47) <= std_logic_vector(signed(A(32 to 47)) + signed(Imm(8 to 17)));
        Result(48 to 63) <= std_logic_vector(signed(A(48 to 63)) + signed(Imm(8 to 17)));
        Result(64 to 79) <= std_logic_vector(signed(A(64 to 79)) + signed(Imm(8 to 17)));
        Result(80 to 95) <= std_logic_vector(signed(A(80 to 95)) + signed(Imm(8 to 17)));
        Result(96 to 111) <= std_logic_vector(signed(A(96 to 111)) + signed(Imm(8 to 17)));
        Result(112 to 127) <= std_logic_vector(signed(A(112 to 127)) + signed(Imm(8 to 17)));
    when OP_ADD_WORD =>
        Result(0 to 31) <= std_logic_vector(signed(A(0 to 31)) + signed(B(0 to 31)));
        Result(32 to 63) <= std_logic_vector(signed(A(32 to 63)) + signed(B(32 to 63)));
        Result(64 to 95) <= std_logic_vector(signed(A(64 to 95)) + signed(B(64 to 95)));
        Result(96 to 127) <= std_logic_vector(signed(A(96 to 127)) + signed(B(96 to 127)));
    when OP_ADD_WORD_IMMEDIATE =>
        Result(0 to 31) <= std_logic_vector(signed(A(0 to 31)) + signed(Imm(8 to 17)));
        Result(32 to 63) <= std_logic_vector(signed(A(32 to 63)) + signed(Imm(8 to 17)));
        Result(64 to 95) <= std_logic_vector(signed(A(64 to 95)) + signed(Imm(8 to 17)));
        Result(96 to 127) <= std_logic_vector(signed(A(96 to 127)) + signed(Imm(8 to 17)));
    when OP_SUBTRACT_FROM_HALFWORD =>
        Result(0 to 15) <= std_logic_vector(signed(B(0 to 15)) - signed(A(0 to 15)));
        Result(16 to 31) <= std_logic_vector(signed(B(16 to 31)) - signed(A(16 to 31)));
        Result(32 to 47) <= std_logic_vector(signed(B(32 to 47)) - signed(A(32 to 47)));
        Result(48 to 63) <= std_logic_vector(signed(B(48 to 63)) - signed(A(48 to 63)));
        Result(64 to 79) <= std_logic_vector(signed(B(64 to 79)) - signed(A(64 to 79)));
        Result(80 to 95) <= std_logic_vector(signed(B(80 to 95)) - signed(A(80 to 95)));
        Result(96 to 111) <= std_logic_vector(signed(B(96 to 111)) - signed(A(96 to 111)));
        Result(112 to 127) <= std_logic_vector(signed(B(112 to 127)) - signed(A(112 to 127)));
    when OP_SUBTRACT_FROM_HALFWORD_IMMEDIATE =>
        Result(0 to 15) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(0 to 15)));
        Result(16 to 31) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(16 to 31)));
        Result(32 to 47) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(32 to 47)));
        Result(48 to 63) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(48 to 63)));
        Result(64 to 79) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(64 to 79)));
        Result(80 to 95) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(80 to 95)));
        Result(96 to 111) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(96 to 111)));
        Result(112 to 127) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(112 to 127)));
    when OP_SUBTRACT_FROM_WORD =>
        Result(0 to 31) <= std_logic_vector(signed(B(0 to 31)) - signed(A(0 to 31)));
        Result(32 to 63) <= std_logic_vector(signed(B(32 to 63)) - signed(A(32 to 63)));
        Result(64 to 95) <= std_logic_vector(signed(B(64 to 95)) - signed(A(64 to 95)));
        Result(96 to 127) <= std_logic_vector(signed(B(96 to 127)) - signed(A(96 to 127)));
    when OP_SUBTRACT_FROM_WORD_IMMEDIATE =>
        Result(0 to 31) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(0 to 31)));
        Result(32 to 63) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(32 to 63)));
        Result(64 to 95) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(64 to 95)));
        Result(96 to 127) <= std_logic_vector(signed(Imm(8 to 17)) - signed(A(96 to 127)));
    when OP_COUNT_LEADING_ZEROS =>
        Result(0 to 31) <= std_logic_vector(to_unsigned(count_leading_zeros(A(0 to 31)), 32));
        Result(32 to 63) <= std_logic_vector(to_unsigned(count_leading_zeros(A(32 to 63)), 32));
        Result(64 to 95) <= std_logic_vector(to_unsigned(count_leading_zeros(A(64 to 95)), 32));
        Result(96 to 127) <= std_logic_vector(to_unsigned(count_leading_zeros(A(96 to 127)), 32));
    when OP_AND =>
        Result <= A and B;
    when OP_OR =>
        Result <= A or B;
    when OP_XOR =>
        Result <= A xor B;
    when OP_NAND =>
        Result <= A nand B;
    when OP_NOR =>
        Result <= A nor B;
    when OP_COMPARE_EQUAL_HALFWORD =>
        Result(0 to 15) <= (others => '1') when A(0 to 15) = B(0 to 15) else (others => '0');
        Result(16 to 31) <= (others => '1') when A(16 to 31) = B(16 to 31) else (others => '0');
        Result(32 to 47) <= (others => '1') when A(32 to 47) = B(32 to 47) else (others => '0');
        Result(48 to 63) <= (others => '1') when A(48 to 63) = B(48 to 63) else (others => '0');
        Result(64 to 79) <= (others => '1') when A(64 to 79) = B(64 to 79) else (others => '0');
        Result(80 to 95) <= (others => '1') when A(80 to 95) = B(80 to 95) else (others => '0');
        Result(96 to 111) <= (others => '1') when A(96 to 111) = B(96 to 111) else (others => '0');
        Result(112 to 127) <= (others => '1') when A(112 to 127) = B(112 to 127) else (others => '0');
    when OP_COMPARE_EQUAL_WORD =>
        Result(0 to 31) <= (others => '1') when A(0 to 31) = B(0 to 31) else (others => '0');
        Result(32 to 63) <= (others => '1') when A(32 to 63) = B(32 to 63) else (others => '0');
        Result(64 to 95) <= (others => '1') when A(64 to 95) = B(64 to 95) else (others => '0');
        Result(96 to 127) <= (others => '1') when A(96 to 127) = B(96 to 127) else (others => '0');
    when OP_COMPARE_EQUAL_WORD_IMMEDIATE =>
        Result(0 to 31) <= (others => '1') when A(0 to 31) = (0 to 21 => Imm(8))&Imm(8 to 17) else (others => '0');
        Result(32 to 63) <= (others => '1') when A(32 to 63) = (0 to 21 => Imm(8))&Imm(8 to 17) else (others => '0');
        Result(64 to 95) <= (others => '1') when A(64 to 95) = (0 to 21 => Imm(8))&Imm(8 to 17) else (others => '0');
        Result(96 to 127) <= (others => '1') when A(96 to 127) = (0 to 21 => Imm(8))&Imm(8 to 17) else (others => '0');
    when OP_COMPARE_GREATER_THAN_HALFWORD =>
        Result(0 to 15) <= (others => '1') when signed(A(0 to 15)) > signed(B(0 to 15)) else (others => '0');
        Result(16 to 31) <= (others => '1') when signed(A(16 to 31)) > signed(B(16 to 31)) else (others => '0');
        Result(32 to 47) <= (others => '1') when signed(A(32 to 47)) > signed(B(32 to 47)) else (others => '0');
        Result(48 to 63) <= (others => '1') when signed(A(48 to 63)) > signed(B(48 to 63)) else (others => '0');
        Result(64 to 79) <= (others => '1') when signed(A(64 to 79)) > signed(B(64 to 79)) else (others => '0');
        Result(80 to 95) <= (others => '1') when signed(A(80 to 95)) > signed(B(80 to 95)) else (others => '0');
        Result(96 to 111) <= (others => '1') when signed(A(96 to 111)) > signed(B(96 to 111)) else (others => '0');
        Result(112 to 127) <= (others => '1') when signed(A(112 to 127)) > signed(B(112 to 127)) else (others => '0');
     when OP_COMPARE_GREATER_THAN_WORD =>
        Result(0 to 31) <= (others => '1') when signed(A(0 to 31)) > signed(B(0 to 31)) else (others => '0');
        Result(32 to 63) <= (others => '1') when signed(A(32 to 63)) > signed(B(32 to 63)) else (others => '0');
        Result(64 to 95) <= (others => '1') when signed(A(64 to 95)) > signed(B(64 to 95)) else (others => '0');
        Result(96 to 127) <= (others => '1') when signed(A(96 to 127)) > signed(B(96 to 127)) else (others => '0');
    when OP_COMPARE_GREATER_THAN_WORD_IMMEDIATE =>
        Result(0 to 31) <= (others => '1') when signed(A(0 to 31)) > signed((0 to 21 => Imm(8))&Imm(8 to 17)) else (others => '0');
        Result(32 to 63) <= (others => '1') when signed(A(32 to 63)) > signed((0 to 21 => Imm(8))&Imm(8 to 17)) else (others => '0');
        Result(64 to 95) <= (others => '1') when signed(A(64 to 95)) > signed((0 to 21 => Imm(8))&Imm(8 to 17)) else (others => '0');
        Result(96 to 127) <= (others => '1') when signed(A(96 to 127)) > signed((0 to 21 => Imm(8))&Imm(8 to 17)) else (others => '0');
    when OP_COMPARE_LOGICAL_GREATER_THAN_HALFWORD =>
        Result(0 to 15) <= (others => '1') when unsigned(A(0 to 15)) > unsigned(B(0 to 15)) else (others => '0');
        Result(16 to 31) <= (others => '1') when unsigned(A(16 to 31)) > unsigned(B(16 to 31)) else (others => '0');
        Result(32 to 47) <= (others => '1') when unsigned(A(32 to 47)) > unsigned(B(32 to 47)) else (others => '0');
        Result(48 to 63) <= (others => '1') when unsigned(A(48 to 63)) > unsigned(B(48 to 63)) else (others => '0');
        Result(64 to 79) <= (others => '1') when unsigned(A(64 to 79)) > unsigned(B(64 to 79)) else (others => '0');
        Result(80 to 95) <= (others => '1') when unsigned(A(80 to 95)) > unsigned(B(80 to 95)) else (others => '0');
        Result(96 to 111) <= (others => '1') when unsigned(A(96 to 111)) > unsigned(B(96 to 111)) else (others => '0');
        Result(112 to 127) <= (others => '1') when unsigned(A(112 to 127)) > unsigned(B(112 to 127)) else (others => '0');
    when OP_COMPARE_LOGICAL_GREATER_THAN_WORD =>
        Result(0 to 31) <= (others => '1') when unsigned(A(0 to 31)) > unsigned(B(0 to 31)) else (others => '0');
        Result(32 to 63) <= (others => '1') when unsigned(A(32 to 63)) > unsigned(B(32 to 63)) else (others => '0');
        Result(64 to 95) <= (others => '1') when unsigned(A(64 to 95)) > unsigned(B(64 to 95)) else (others => '0');
        Result(96 to 127) <= (others => '1') when unsigned(A(96 to 127)) > unsigned(B(96 to 127)) else (others => '0');
    when OP_COMPARE_LOGICAL_GREATER_THAN_WORD_IMMEDIATE =>
        Result(0 to 31) <= (others => '1') when unsigned(A(0 to 31)) > unsigned((0 to 21 => Imm(8))&Imm(8 to 17)) else (others => '0');
        Result(32 to 63) <= (others => '1') when unsigned(A(32 to 63)) > unsigned((0 to 21 => Imm(8))&Imm(8 to 17)) else (others => '0');
        Result(64 to 95) <= (others => '1') when unsigned(A(64 to 95)) > unsigned((0 to 21 => Imm(8))&Imm(8 to 17)) else (others => '0');
        Result(96 to 127) <= (others => '1') when unsigned(A(96 to 127)) > unsigned((0 to 21 => Imm(8))&Imm(8 to 17)) else (others => '0');
    end case;
end process;

end architecture;