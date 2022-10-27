library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity branch_unit is
port(
    op_sel : in  std_logic_vector(0 to 2);
    A      : in  std_logic_vector(0 to 127);
    T      : in  std_logic_vector(0 to 127);
    Imm    : in  std_logic_vector(0 to 15);
    PC     : in  std_logic_vector(0 to 31);
    Result : out std_logic_vector(0 to 31);
    PCWr   : out std_logic
);
end entity;

architecture rtl of branch_unit is

signal op : branch_unit_op_t;

begin

op <= branch_unit_op_t'val(to_integer(unsigned(op_sel)));

process(all)
begin
    case op is
    when OP_NULL =>
        Result <= (others => '0');
        PCWr <= '0';
    when OP_BRANCH_RELATIVE =>
        Result <= std_logic_vector(resize(signed("0"&PC) + signed(Imm(0 to 15) & "00"), 32));
        PCWr <= '1';
    when OP_BRANCH_ABSOLUTE =>
        Result <= (0 to 13 => Imm(0)) & Imm(0 to 15) & "00";
        PCWr <= '1';
    when OP_BRANCH_INDIRECT =>
        Result <= A(0 to 29) & "00";
        PCWr <= '1';
    when OP_BRANCH_IF_NOT_ZERO_WORD =>
        Result <= std_logic_vector(resize(signed("0"&PC) + signed(Imm(0 to 15) & "00"), 32));
        PCWr <= '1' when or T(0 to 31) else '0';
    when OP_BRANCH_IF_ZERO_WORD =>
        Result <= std_logic_vector(resize(signed("0"&PC) + signed(Imm(0 to 15) & "00"), 32));
        PCWr <= '1' when nor T(0 to 31) else '0';
    when OP_BRANCH_IF_NOT_ZERO_HALFWORD =>
        Result <= std_logic_vector(resize(signed("0"&PC) + signed(Imm(0 to 15) & "00"), 32));
        PCWr <= '1' when or T(16 to 31) else '0';
    when OP_BRANCH_IF_ZERO_HALFWORD =>
        Result <= std_logic_vector(resize(signed("0"&PC) + signed(Imm(0 to 15) & "00"), 32));
        PCWr <= '1' when nor T(16 to 31) else '0';
    end case;
end process;

end architecture;