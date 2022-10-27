library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity mem_unit is
port(
    clk      : in  std_logic;

	branch_mispredict : in  std_logic;
	stall    : out std_logic;
	mem_rd	 : out std_logic;
	mem_wr	 : out std_logic;
	op_done	 : in  std_logic;
	mem_addr : out std_logic_vector(0 to 13);
	wr_data	 : out std_logic_vector(0 to 127);
	rd_data	 : in  std_logic_vector(0 to 127);
	op_ll    : out std_logic;
	op_sc    : out std_logic;

    op_sel   : in  std_logic_vector(0 to 3);
    A        : in  std_logic_vector(0 to 127);
    B        : in  std_logic_vector(0 to 127);
    T        : in  std_logic_vector(0 to 127);
    Imm      : in  std_logic_vector(0 to 15);
    Result   : out std_logic_vector(0 to 127)
);
end entity;

architecture rtl of mem_unit is

constant LSLR : std_logic_vector(0 to 31) := x"0003FFFF";
signal op : local_store_unit_op_t;
signal LSA : std_logic_vector(0 to 31);

signal stall_q : std_logic;

signal LSA_reg, LSA_latch : std_logic_vector(0 to 31);
signal T_reg, T_latch : std_logic_vector(0 to 127);

begin

op <= local_store_unit_op_t'val(to_integer(unsigned(op_sel)));

process(all)
begin
    case op is
        when OP_LOAD_QUADWORD_D | OP_STORE_QUADWORD_D =>
            LSA <=  std_logic_vector(resize(unsigned(std_logic_vector(signed(Imm(6 to 15))&"0000" + signed("0"&A(0 to 31)))), 32)) and LSLR and x"FFFFFFF0";
        when OP_LOAD_QUADWORD_X | OP_STORE_QUADWORD_X =>
            LSA <=  std_logic_vector(unsigned(A(0 to 31)) + unsigned(B(0 to 31))) and LSLR and x"FFFFFFF0";
        when OP_LOAD_QUADWORD_A | OP_STORE_QUADWORD_A =>
			LSA <=  std_logic_vector(unsigned((0 to 13 => Imm(0)) & Imm(0 to 15) & "00")) and LSLR and x"FFFFFFF0";
		when OP_LOAD_LINKED | OP_STORE_CONDITIONAL =>
			LSA <=  std_logic_vector(resize(unsigned(std_logic_vector(signed(Imm(6 to 15))&"0000" + signed("0"&A(0 to 31)))), 32)) and LSLR and x"FFFFFFF0";
        when OP_NULL =>
			LSA <= (others => '0');
    end case;
end process;

process(clk)
begin
	if rising_edge(clk) then
		if not stall_q then
			LSA_reg <= LSA;
			T_reg <= T;
		end if;
	end if;
end process;

LSA_latch <= LSA_reg when stall_q else LSA;
T_latch <= T_reg when stall_q else T;

mem_addr <= LSA_latch(14 to 27);
wr_data <= T_latch;
Result <= rd_data;
stall <= '1' when op /= OP_NULL and op_done = '0' else '0';
stall_q <= stall when rising_edge(clk);
op_ll <= '1' when op = OP_LOAD_LINKED else '0';
op_sc <= '1' when op = OP_STORE_CONDITIONAL else '0';

process(all)
begin
	mem_rd <= '0';
	mem_wr <= '0';
	if not branch_mispredict then
		case op is
		when OP_LOAD_QUADWORD_D | OP_LOAD_QUADWORD_X | OP_LOAD_QUADWORD_A =>
			mem_rd <= not stall_q;
		when OP_STORE_QUADWORD_D | OP_STORE_QUADWORD_X | OP_STORE_QUADWORD_A =>
			mem_wr <= not stall_q;
		when OP_LOAD_LINKED =>
			mem_rd <= not stall_q;
		when OP_STORE_CONDITIONAL =>
			mem_wr <= not stall_q;
		when OP_NULL => null;
		end case;
	end if;
end process;

end architecture;