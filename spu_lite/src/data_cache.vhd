library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library std;
use std.textio.all;

entity data_cache is
generic(
	LINE_SIZE_BYTES : natural := 64;
	MEM_SIZE_KBYTES : natural := 256;
	INIT : boolean := true
);
port(
	clk 	: in  std_logic;
	wr_en	: in  std_logic;
	addr	: in  std_logic_vector(0 to integer(log2(real(MEM_SIZE_KBYTES * 2**10 / LINE_SIZE_BYTES))) - 1);
	wr_data : in  std_logic_vector(0 to LINE_SIZE_BYTES * 8 - 1);
	rd_data : out std_logic_vector(0 to LINE_SIZE_BYTES * 8 - 1)
);
end entity;

architecture rtl of data_cache is

type mem_t is array (0 to MEM_SIZE_KBYTES * 2**10 / LINE_SIZE_BYTES - 1) of std_logic_vector(0 to LINE_SIZE_BYTES * 8 - 1);

function mem_init (filename : string) return mem_t is
    file text_var : text;
    variable line_var : line;
	variable data : std_logic_vector(0 to 127);
    variable line_num : natural := 0;
    variable init_mem : mem_t := (others => (others => '0'));
begin
	if INIT then
	    -- Initialize memory from file
	    file_open(text_var, filename, read_mode);
	    while not endfile(text_var) loop
	        readLine(text_var, line_var);
			hread(line_var, data);
	        init_mem(line_num / 4)(128*(line_num mod 4) to 128*(line_num mod 4) + 127) := data;
	        line_num := line_num + 1;
	    end loop;
	    file_close(text_var);
	end if;
    return init_mem;
end function;

signal mem : mem_t := mem_init("mem_init.txt");

begin

	rd_data <= mem(to_integer(unsigned(addr)));

	mem(to_integer(unsigned(addr))) <= wr_data when rising_edge(clk) and wr_en = '1';

end architecture;
