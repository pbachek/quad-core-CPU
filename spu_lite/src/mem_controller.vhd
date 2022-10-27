library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity mem_controller is
port(
	clk             : in  std_logic;
	-- Addr bus
	bus_addr_busy   : in  std_logic;
	bus_addr		: in  std_logic_vector(0 to 11);
	bus_sourceID	: in  std_logic_vector(0 to 1);
	bus_cmd			: in  std_logic_vector(0 to 1);
	bus_shared		: in  std_logic;
	bus_modified	: in  std_logic;
	-- Data bus
	mem_data_req    : out std_logic := '0';
	mem_data_gnt    : in  std_logic;
	mem_data		: out std_logic_vector(0 to 255);
	mem_dataID		: out std_logic_vector(0 to 1) := 2x"0";
	bus_data_busy   : in  std_logic;
	bus_data		: in  std_logic_vector(0 to 255);
	bus_dataID		: in  std_logic_vector(0 to 1)
);
end entity;

architecture rtl of mem_controller is

component data_cache is
generic(
	LINE_SIZE_BYTES : natural := 64;
	MEM_SIZE_KBYTES : natural := 256;
	INIT : boolean := false
);
port(
	clk 	: in  std_logic;
	wr_en	: in  std_logic;
	addr	: in  std_logic_vector(0 to integer(log2(real(MEM_SIZE_KBYTES * 2**10 / LINE_SIZE_BYTES))) - 1);
	wr_data : in  std_logic_vector(0 to LINE_SIZE_BYTES * 8 - 1);
	rd_data : out std_logic_vector(0 to LINE_SIZE_BYTES * 8 - 1)
);
end component;

type request_table_entry_t is record
	valid : std_logic;
	addr  : std_logic_vector(0 to 11);
	bus_cmd : std_logic_vector(0 to 1);
	modified : std_logic;
end record;
type request_table_t is array(0 to 3) of request_table_entry_t;
signal request_table : request_table_t := (others => ('0', (others => '0'), "00", '0'));

signal bus_addr_busy_q 	: std_logic;
signal bus_data_busy_q  : std_logic;

signal response_busy : std_logic := '0';
signal response_state : integer range 0 to 7 := 0;

signal data_in_buf  : std_logic_vector(0 to 511);

signal mem_wr_en : std_logic;
signal mem_addr : std_logic_vector(0 to 11);
signal mem_wr_data : std_logic_vector(0 to 511);
signal mem_rd_data : std_logic_vector(0 to 511);

begin

-----------------------------------------------------------------------------------
-- Bus side controller
-----------------------------------------------------------------------------------
-- Data going to data bus
mem_data <= mem_rd_data(0 to 255) when bus_data_busy and not bus_data_busy_q else mem_rd_data(256 to 511);

-- Address bus snooper, request table
process(clk)
begin
	if rising_edge(clk) then
		--Registers
		bus_addr_busy_q <= bus_addr_busy;
		bus_data_busy_q <= bus_data_busy;
		-- Default values
		mem_wr_en <= '0';

		-- Snoop address bus to fill request table
		if (bus_addr_busy and bus_addr_busy_q) = '1' then
			request_table(to_integer(unsigned(bus_sourceID))) <= ('1', bus_addr, bus_cmd, bus_modified);
		end if;

		-- Check request table
		for i in request_table'range loop
			if request_table(i).valid then
				case command_t'val(to_integer(unsigned(request_table(i).bus_cmd))) is
				-- if snoop bus read
				when BUS_RD =>
					-- reply if line is not modified
					if not request_table(i).modified then
						if not response_busy then
							request_table(i).valid <= '0';
							mem_dataID <= std_logic_vector(to_unsigned(i,2));
							response_busy <= '1';
						end if;
						exit;
					end if;
				-- if snoop bus read exclusive
				when BUS_RDX =>
					-- reply if line is not modified
					if not request_table(i).modified then
						if not response_busy then
							request_table(i).valid <= '0';
							mem_dataID <= std_logic_vector(to_unsigned(i,2));
							response_busy <= '1';
						end if;
						exit;
					end if;
				-- if snoop bus upgrade, ignore
				when BUS_UPGR => null;
				-- if snoop flush operation, ignore
				when FLUSH => null;
				end case;
			end if;
		end loop;

		-- response data state machine
		if response_busy then
			if response_state = 0 then
				mem_data_req <= '1';
				mem_addr <= request_table(to_integer(unsigned(mem_dataID))).addr;
				if mem_data_gnt then
					mem_data_req <= '0';
					response_state <= 1;
				end if;
			elsif response_state = 1 then
				response_state <= 2;
			elsif response_state = 2 then
				response_state <= 0;
				response_busy <= '0';
			end if;
		end if;

		-- snoop data bus
		if bus_data_busy and bus_data_busy_q then
			-- Check request table
			for i in request_table'range loop
				if request_table(i).valid = '1' and i = to_integer(unsigned(bus_dataID)) then
					case command_t'val(to_integer(unsigned(request_table(i).bus_cmd))) is
					-- if snoop bus read
					when BUS_RD =>
						-- write data if line is modified
						if request_table(i).modified then
							mem_wr_en <= '1';
							mem_addr <= request_table(i).addr;
							request_table(i).valid <= '0';
							exit;
						end if;
					-- if snoop bus read exclusive
					when BUS_RDX =>
						-- write data if line is modified
						if request_table(i).modified then
							mem_wr_en <= '1';
							mem_addr <= request_table(i).addr;
							request_table(i).valid <= '0';
							exit;
						end if;
					-- if snoop bus upgrade
					when BUS_UPGR =>
						-- write data if line is modified
						if request_table(i).modified then
							mem_wr_en <= '1';
							mem_addr <= request_table(i).addr;
							request_table(i).valid <= '0';
							exit;
						end if;
					-- if snoop flush operation
					when FLUSH =>
						-- write data
						mem_wr_en <= '1';
						mem_addr <= request_table(i).addr;
						request_table(i).valid <= '0';
						exit;
					end case;
				end if;
			end loop;
		end if;
	end if;
end process;

-- Data in buffer
process(clk)
begin
	if rising_edge(clk) then
		if bus_data_busy then
			if bus_data_busy_q then
				data_in_buf(256 to 511) <= bus_data;
			else
				data_in_buf(0 to 255) <= bus_data;
			end if;
		end if;
	end if;
end process;

mem_wr_data <= data_in_buf;

-- 256kB cache
shared_cache_inst : data_cache
generic map(
	LINE_SIZE_BYTES => 64,
	MEM_SIZE_KBYTES => 256,
	INIT => true
)
port map(
	clk => clk,
	wr_en => mem_wr_en,
	addr => mem_addr,
	wr_data => mem_wr_data,
	rd_data => mem_rd_data
);

end architecture;
