library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity single_precision_unit is
port(
    op_sel : in  std_logic_vector(0 to 3);
    A      : in  std_logic_vector(0 to 127);
    B      : in  std_logic_vector(0 to 127);
    C      : in  std_logic_vector(0 to 127);
    Imm    : in  std_logic_vector(0 to 17);
    Result : out std_logic_vector(0 to 127)
);
end entity;

architecture rtl of single_precision_unit is

signal op : single_precision_unit_op_t;

begin

op <= single_precision_unit_op_t'val(to_integer(unsigned(op_sel)));

process(all)
begin
    case op is
    when OP_MULTIPLY =>
        Result(0 to 31) <= std_logic_vector(signed(A(16 to 31)) * signed(B(16 to 31)));
        Result(32 to 63) <= std_logic_vector(signed(A(48 to 63)) * signed(B(48 to 63)));
        Result(64 to 95) <= std_logic_vector(signed(A(80 to 95)) * signed(B(80 to 95)));
        Result(96 to 127) <= std_logic_vector(signed(A(112 to 127)) * signed(B(112 to 127)));
    when OP_MULTIPLY_UNSIGNED =>
        Result(0 to 31) <= std_logic_vector(unsigned(A(16 to 31)) * unsigned(B(16 to 31)));
        Result(32 to 63) <= std_logic_vector(unsigned(A(48 to 63)) * unsigned(B(48 to 63)));
        Result(64 to 95) <= std_logic_vector(unsigned(A(80 to 95)) * unsigned(B(80 to 95)));
        Result(96 to 127) <= std_logic_vector(unsigned(A(112 to 127)) * unsigned(B(112 to 127)));
    when OP_MULTIPLY_IMMEDIATE =>
        Result(0 to 31) <= std_logic_vector(resize(signed(A(16 to 31)) * signed(Imm(8 to 17)), 32));
        Result(32 to 63) <= std_logic_vector(resize(signed(A(48 to 63)) * signed(Imm(8 to 17)), 32));
        Result(64 to 95) <= std_logic_vector(resize(signed(A(80 to 95)) * signed(Imm(8 to 17)), 32));
        Result(96 to 127) <= std_logic_vector(resize(signed(A(112 to 127)) * signed(Imm(8 to 17)), 32));
    when OP_MULTIPLY_UNSIGNED_IMMEDIATE =>
        Result(0 to 31) <= std_logic_vector(unsigned(A(16 to 31)) * unsigned(std_logic_vector(resize(signed(Imm(8 to 17)), 16))));
        Result(32 to 63) <= std_logic_vector(unsigned(A(48 to 63)) * unsigned(std_logic_vector(resize(signed(Imm(8 to 17)), 16))));
        Result(64 to 95) <= std_logic_vector(unsigned(A(80 to 95)) * unsigned(std_logic_vector(resize(signed(Imm(8 to 17)), 16))));
        Result(96 to 127) <= std_logic_vector(unsigned(A(112 to 127)) * unsigned(std_logic_vector(resize(signed(Imm(8 to 17)), 16))));
    when OP_FLOATING_COMPARE_EQUAL =>
        Result(0 to 31) <= (others => '1') when to_float(A(0 to 31)) = to_float(B(0 to 31)) else (others => '0');
        Result(32 to 63) <= (others => '1') when to_float(A(32 to 63)) = to_float(B(32 to 63)) else (others => '0');
        Result(64 to 95) <= (others => '1') when to_float(A(64 to 95)) = to_float(B(64 to 95)) else (others => '0');
        Result(96 to 127) <= (others => '1') when to_float(A(96 to 127)) = to_float(B(96 to 127)) else (others => '0');
    when OP_FLOATING_COMPARE_GREATER_THAN =>
        Result(0 to 31) <= (others => '1') when to_float(A(0 to 31)) > to_float(B(0 to 31)) else (others => '0');
        Result(32 to 63) <= (others => '1') when to_float(A(32 to 63)) > to_float(B(32 to 63)) else (others => '0');
        Result(64 to 95) <= (others => '1') when to_float(A(64 to 95)) > to_float(B(64 to 95)) else (others => '0');
        Result(96 to 127) <= (others => '1') when to_float(A(96 to 127)) > to_float(B(96 to 127)) else (others => '0');
    when OP_FLOATING_ADD =>
        Result(0 to 31) <= std_logic_vector(to_float(A(0 to 31)) + to_float(B(0 to 31)));
        Result(32 to 63) <= std_logic_vector(to_float(A(32 to 63)) + to_float(B(32 to 63)));
        Result(64 to 95) <= std_logic_vector(to_float(A(64 to 95)) + to_float(B(64 to 95)));
        Result(96 to 127) <= std_logic_vector(to_float(A(96 to 127)) + to_float(B(96 to 127)));
    when OP_FLOATING_SUBTRACT =>
        Result(0 to 31) <= std_logic_vector(to_float(A(0 to 31)) - to_float(B(0 to 31)));
        Result(32 to 63) <= std_logic_vector(to_float(A(32 to 63)) - to_float(B(32 to 63)));
        Result(64 to 95) <= std_logic_vector(to_float(A(64 to 95)) - to_float(B(64 to 95)));
        Result(96 to 127) <= std_logic_vector(to_float(A(96 to 127)) - to_float(B(96 to 127)));
    when OP_FLOATING_MULTIPLY =>
        Result(0 to 31) <= std_logic_vector(to_float(A(0 to 31)) * to_float(B(0 to 31)));
        Result(32 to 63) <= std_logic_vector(to_float(A(32 to 63)) * to_float(B(32 to 63)));
        Result(64 to 95) <= std_logic_vector(to_float(A(64 to 95)) * to_float(B(64 to 95)));
        Result(96 to 127) <= std_logic_vector(to_float(A(96 to 127)) * to_float(B(96 to 127)));
    when OP_FLOATING_MULTIPLY_AND_ADD =>
        Result(0 to 31) <= std_logic_vector(to_float(A(0 to 31)) * to_float(B(0 to 31)) + to_float(C(0 to 31)));
        Result(32 to 63) <= std_logic_vector(to_float(A(32 to 63)) * to_float(B(32 to 63)) + to_float(C(32 to 63)));
        Result(64 to 95) <= std_logic_vector(to_float(A(64 to 95)) * to_float(B(64 to 95)) + to_float(C(64 to 95)));
        Result(96 to 127) <= std_logic_vector(to_float(A(96 to 127)) * to_float(B(96 to 127)) + to_float(C(96 to 127)));
    when OP_CONVERT_SIGNED_INTEGER_TO_FLOATING =>
        Result(0 to 31) <= std_logic_vector(to_float(signed(A(0 to 31))) / 2.0**(155-to_integer(unsigned(Imm(10 to 17)))));
        Result(32 to 63) <= std_logic_vector(to_float(signed(A(32 to 63))) / 2.0**(155-to_integer(unsigned(Imm(10 to 17)))));
        Result(64 to 95) <= std_logic_vector(to_float(signed(A(64 to 95))) / 2.0**(155-to_integer(unsigned(Imm(10 to 17)))));
        Result(96 to 127) <= std_logic_vector(to_float(signed(A(96 to 127))) / 2.0**(155-to_integer(unsigned(Imm(10 to 17)))));
    when OP_CONVERT_FLOATING_TO_SIGNED_INTEGER =>
        Result(0 to 31) <= std_logic_vector(to_signed(to_float(A(0 to 31)) * 2.0**(173-to_integer(unsigned(Imm(10 to 17)))), 32));
        Result(32 to 63) <= std_logic_vector(to_signed(to_float(A(32 to 63)) * 2.0**(173-to_integer(unsigned(Imm(10 to 17)))), 32));
        Result(64 to 95) <= std_logic_vector(to_signed(to_float(A(64 to 95)) * 2.0**(173-to_integer(unsigned(Imm(10 to 17)))), 32));
        Result(96 to 127) <= std_logic_vector(to_signed(to_float(A(96 to 127)) * 2.0**(173-to_integer(unsigned(Imm(10 to 17)))), 32));
    end case;
end process;

end architecture;