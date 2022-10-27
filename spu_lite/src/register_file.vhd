library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
port(
    clk       : in  std_logic;

    A_rd_addr : in  std_logic_vector(0 to 6);
    A_rd_data : out std_logic_vector(0 to 127) := (others => '0');

    B_rd_addr : in  std_logic_vector(0 to 6);
    B_rd_data : out std_logic_vector(0 to 127) := (others => '0');

    C_rd_addr : in  std_logic_vector(0 to 6);
    C_rd_data : out std_logic_vector(0 to 127) := (others => '0');

    D_rd_addr : in  std_logic_vector(0 to 6);
    D_rd_data : out std_logic_vector(0 to 127) := (others => '0');

    E_rd_addr : in  std_logic_vector(0 to 6);
    E_rd_data : out std_logic_vector(0 to 127) := (others => '0');

    F_rd_addr : in  std_logic_vector(0 to 6);
    F_rd_data : out std_logic_vector(0 to 127) := (others => '0');

    A_wr_en   : in  std_logic;
    A_wr_addr : in  std_logic_vector(0 to 6);
    A_wr_data : in  std_logic_vector(0 to 127);

    B_wr_en   : in  std_logic;
    B_wr_addr : in  std_logic_vector(0 to 6);
    B_wr_data : in  std_logic_vector(0 to 127)
);
end entity;

architecture rtl of register_file is

type regs_t is array (0 to 127) of std_logic_vector(0 to 127);
signal registers : regs_t := (others => (others => '0'));

begin

read_process : process(clk)
begin
    if rising_edge(clk) then
		if A_rd_addr = A_wr_addr and A_wr_en = '1' then
			A_rd_data <= A_wr_data;
		elsif A_rd_addr = B_wr_addr and B_wr_en = '1' then
			A_rd_data <= B_wr_data;
		else
			A_rd_data <= registers(to_integer(unsigned(A_rd_addr)));
		end if;

		if B_rd_addr = A_wr_addr and A_wr_en = '1' then
			B_rd_data <= A_wr_data;
		elsif B_rd_addr = B_wr_addr and B_wr_en = '1' then
			B_rd_data <= B_wr_data;
		else
			B_rd_data <= registers(to_integer(unsigned(B_rd_addr)));
		end if;

		if C_rd_addr = A_wr_addr and A_wr_en = '1' then
			C_rd_data <= A_wr_data;
		elsif C_rd_addr = B_wr_addr and B_wr_en = '1' then
			C_rd_data <= B_wr_data;
		else
			C_rd_data <= registers(to_integer(unsigned(C_rd_addr)));
		end if;

		if D_rd_addr = A_wr_addr and A_wr_en = '1' then
			D_rd_data <= A_wr_data;
		elsif D_rd_addr = B_wr_addr and B_wr_en = '1' then
			D_rd_data <= B_wr_data;
		else
			D_rd_data <= registers(to_integer(unsigned(D_rd_addr)));
		end if;

		if E_rd_addr = A_wr_addr and A_wr_en = '1' then
			E_rd_data <= A_wr_data;
		elsif E_rd_addr = B_wr_addr and B_wr_en = '1' then
			E_rd_data <= B_wr_data;
		else
			E_rd_data <= registers(to_integer(unsigned(E_rd_addr)));
		end if;

		if F_rd_addr = A_wr_addr and A_wr_en = '1' then
			F_rd_data <= A_wr_data;
		elsif F_rd_addr = B_wr_addr and B_wr_en = '1' then
			F_rd_data <= B_wr_data;
		else
			F_rd_data <= registers(to_integer(unsigned(F_rd_addr)));
		end if;
	end if;
end process;

write_process : process(clk)
begin
    if rising_edge(clk) then
        if A_wr_en then
            registers(to_integer(unsigned(A_wr_addr))) <= A_wr_data;
        end if;

        if B_wr_en then
            registers(to_integer(unsigned(B_wr_addr))) <= B_wr_data;
        end if;
    end if;
end process;

end architecture;