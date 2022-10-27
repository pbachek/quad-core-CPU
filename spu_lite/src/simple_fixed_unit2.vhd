library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity simple_fixed_unit2 is
port(
    op_sel : in  std_logic_vector(0 to 2);
    A      : in  std_logic_vector(0 to 127);
    B      : in  std_logic_vector(0 to 127);
    Imm    : in  std_logic_vector(0 to 17);
    Result : out std_logic_vector(0 to 127)
);
end entity;

architecture rtl of simple_fixed_unit2 is

signal op : simple_fixed_unit2_op_t;

begin

op <= simple_fixed_unit2_op_t'val(to_integer(unsigned(op_sel)));

process(all)
begin
    case op is
    when OP_SHIFT_LEFT_HALFWORD =>
        Result(0 to 15) <= A(0 to 15) sll to_integer(unsigned(B(11 to 15)));
        Result(16 to 31) <= A(16 to 31) sll to_integer(unsigned(B(27 to 31)));
        Result(32 to 47) <= A(32 to 47) sll to_integer(unsigned(B(43 to 47)));
        Result(48 to 63) <= A(48 to 63) sll to_integer(unsigned(B(59 to 63)));
        Result(64 to 79) <= A(64 to 79) sll to_integer(unsigned(B(75 to 79)));
        Result(80 to 95) <= A(80 to 95) sll to_integer(unsigned(B(91 to 95)));
        Result(96 to 111) <= A(96 to 111) sll to_integer(unsigned(B(107 to 111)));
        Result(112 to 127) <= A(112 to 127) sll to_integer(unsigned(B(123 to 127)));
    when OP_SHIFT_LEFT_HALFWORD_IMMEDIATE =>
        Result(0 to 15) <= A(0 to 15) sll to_integer(unsigned(Imm(13 to 17)));
        Result(16 to 31) <= A(16 to 31) sll to_integer(unsigned(Imm(13 to 17)));
        Result(32 to 47) <= A(32 to 47) sll to_integer(unsigned(Imm(13 to 17)));
        Result(48 to 63) <= A(48 to 63) sll to_integer(unsigned(Imm(13 to 17)));
        Result(64 to 79) <= A(64 to 79) sll to_integer(unsigned(Imm(13 to 17)));
        Result(80 to 95) <= A(80 to 95) sll to_integer(unsigned(Imm(13 to 17)));
        Result(96 to 111) <= A(96 to 111) sll to_integer(unsigned(Imm(13 to 17)));
        Result(112 to 127) <= A(112 to 127) sll to_integer(unsigned(Imm(13 to 17)));
    when OP_SHIFT_LEFT_WORD =>
        Result(0 to 31) <= A(0 to 31) sll to_integer(unsigned(B(26 to 31)));
        Result(32 to 63) <= A(32 to 63) sll to_integer(unsigned(B(58 to 63)));
        Result(64 to 95) <= A(64 to 95) sll to_integer(unsigned(B(90 to 95)));
        Result(96 to 127) <= A(96 to 127) sll to_integer(unsigned(B(122 to 127)));
    when OP_SHIFT_LEFT_WORD_IMMEDIATE =>
        Result(0 to 31) <= A(0 to 31) sll to_integer(unsigned(Imm(12 to 17)));
        Result(32 to 63) <= A(32 to 63) sll to_integer(unsigned(Imm(12 to 17)));
        Result(64 to 95) <= A(64 to 95) sll to_integer(unsigned(Imm(12 to 17)));
        Result(96 to 127) <= A(96 to 127) sll to_integer(unsigned(Imm(12 to 17)));
    when OP_ROTATE_HALFWORD =>
        Result(0 to 15) <= A(0 to 15) rol to_integer(unsigned(B(12 to 15)));
        Result(16 to 31) <= A(16 to 31) rol to_integer(unsigned(B(28 to 31)));
        Result(32 to 47) <= A(32 to 47) rol to_integer(unsigned(B(44 to 47)));
        Result(48 to 63) <= A(48 to 63) rol to_integer(unsigned(B(60 to 63)));
        Result(64 to 79) <= A(64 to 79) rol to_integer(unsigned(B(76 to 79)));
        Result(80 to 95) <= A(80 to 95) rol to_integer(unsigned(B(92 to 95)));
        Result(96 to 111) <= A(96 to 111) rol to_integer(unsigned(B(108 to 111)));
        Result(112 to 127) <= A(112 to 127) rol to_integer(unsigned(B(124 to 127)));
    when OP_ROTATE_HALFWORD_IMMEDIATE =>
        Result(0 to 15) <= A(0 to 15) rol to_integer(unsigned(Imm(14 to 17)));
        Result(16 to 31) <= A(16 to 31) rol to_integer(unsigned(Imm(14 to 17)));
        Result(32 to 47) <= A(32 to 47) rol to_integer(unsigned(Imm(14 to 17)));
        Result(48 to 63) <= A(48 to 63) rol to_integer(unsigned(Imm(14 to 17)));
        Result(64 to 79) <= A(64 to 79) rol to_integer(unsigned(Imm(14 to 17)));
        Result(80 to 95) <= A(80 to 95) rol to_integer(unsigned(Imm(14 to 17)));
        Result(96 to 111) <= A(96 to 111) rol to_integer(unsigned(Imm(14 to 17)));
        Result(112 to 127) <= A(112 to 127) rol to_integer(unsigned(Imm(14 to 17)));
    when OP_ROTATE_WORD =>
        Result(0 to 31) <= A(0 to 31) rol to_integer(unsigned(B(27 to 31)));
        Result(32 to 63) <= A(32 to 63) rol to_integer(unsigned(B(59 to 63)));
        Result(64 to 95) <= A(64 to 95) rol to_integer(unsigned(B(91 to 95)));
        Result(96 to 127) <= A(96 to 127) rol to_integer(unsigned(B(123 to 127)));
    when OP_ROTATE_WORD_IMMEDIATE =>
        Result(0 to 31) <= A(0 to 31) rol to_integer(unsigned(Imm(13 to 17)));
        Result(32 to 63) <= A(32 to 63) rol to_integer(unsigned(Imm(13 to 17)));
        Result(64 to 95) <= A(64 to 95) rol to_integer(unsigned(Imm(13 to 17)));
        Result(96 to 127) <= A(96 to 127) rol to_integer(unsigned(Imm(13 to 17)));
    end case;
end process;

end architecture;