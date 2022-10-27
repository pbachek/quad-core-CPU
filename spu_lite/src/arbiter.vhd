library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arbiter is
generic(
	WIDTH : natural := 4
);
port(
	clk : in  std_logic;
	en  : in  std_logic;
	req : in  std_logic_vector(0 to WIDTH-1);
	gnt : out std_logic_vector(0 to WIDTH-1)
);
end entity;

architecture round_robin of arbiter is

signal priority : std_logic_vector(0 to WIDTH-1) := (0 => '1', others => '0');
signal gntgnt : std_logic_vector(0 to 2*WIDTH-1);

begin

	process(clk)
	begin
		if rising_edge(clk) then
			if en then
				priority <= priority ror 1 when or gnt;
				gntgnt <= req&req and not std_logic_vector(unsigned(req&req) - unsigned(priority));
			end if;
		end if;
	end process;

	gnt <= req and (gntgnt(0 to WIDTH-1) or gntgnt(WIDTH to 2*WIDTH-1)) and en;

end architecture;
