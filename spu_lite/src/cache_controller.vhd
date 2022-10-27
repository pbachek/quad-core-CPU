library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity cache_controller is
generic(
	ID : natural := 0
);
port(
	clk             : in  std_logic;
	-- Processor interface
	proc_rd			: in  std_logic;
	proc_wr			: in  std_logic;
	proc_op_done	: out std_logic;
	proc_addr		: in  std_logic_vector(0 to 13);
	proc_wr_data	: in  std_logic_vector(0 to 127);
	proc_rd_data	: out std_logic_vector(0 to 127);
	proc_ll			: in  std_logic;
	proc_sc			: in  std_logic;
	-- Addr bus
	p_addr_req		: out std_logic := '0';
	p_addr_gnt		: in  std_logic;
	p_addr			: out std_logic_vector(0 to 11);
	p_sourceID		: out std_logic_vector(0 to 1);
	p_cmd			: out std_logic_vector(0 to 1) := "00";
	p_shared		: out std_logic;
	p_modified		: out std_logic;
	bus_addr_busy   : in  std_logic;
	bus_addr		: in  std_logic_vector(0 to 11);
	bus_sourceID	: in  std_logic_vector(0 to 1);
	bus_cmd			: in  std_logic_vector(0 to 1);
	bus_shared		: in  std_logic;
	bus_modified	: in  std_logic;
	-- Data bus
	p_data_req  	: out std_logic;
	p_data_gnt  	: in  std_logic;
	p_data			: out std_logic_vector(0 to 255);
	p_dataID		: out std_logic_vector(0 to 1);
	bus_data_busy   : in  std_logic;
	bus_data		: in  std_logic_vector(0 to 255);
	bus_dataID		: in  std_logic_vector(0 to 1)
);
end entity;

architecture rtl of cache_controller is

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
	response : std_logic;
end record;
type request_table_t is array(0 to 3) of request_table_entry_t;
signal request_table : request_table_t := (others => ('0', (others => '0'), "00", '0'));

signal state_tag_table : state_tag_table_t := (others => (invalid_t, (others => '0')));

signal snoop_state_new : cache_line_state_t := invalid_t;
signal snoop_state_update : std_logic;
signal snoop_state_index : integer range 0 to 255 := 0;
signal response_busy : std_logic := '0';
signal response_state : integer range 0 to 7 := 0;
signal snoop_mem_addr : std_logic_vector(0 to 7);
signal snoop_dataID : std_logic_vector(0 to 1) := "00";
signal snoop_data_req : std_logic := '0';
signal snoop_data_gnt : std_logic;
signal snoop_mem_access : std_logic := '0';

signal init_bus_rd : std_logic := '0';
signal init_bus_rdx : std_logic := '0';
signal init_bus_upgr : std_logic := '0';
signal init_flush : std_logic := '0';
signal proc_state : integer range 0 to 7 := 0;

signal proc_table_index : integer range 0 to 255;
signal proc_tag_check : std_logic;
signal proc_state_new : cache_line_state_t := invalid_t;
signal proc_state_update : std_logic;
signal proc_tag_update : std_logic;
signal proc_mem_wr_en : std_logic;
signal proc_mem_wr_src : std_logic := '0';
signal proc_mem_wr_data : std_logic_vector(0 to 511);
signal proc_mem_addr : std_logic_vector(0 to 7);
signal proc_dataID : std_logic_vector(0 to 1);
signal proc_data_req : std_logic := '0';
signal proc_data_gnt : std_logic;
signal proc_mem_access : std_logic := '0';
signal proc_rd_latch : std_logic := '0';
signal proc_wr_latch : std_logic := '0';

signal bus_table_index : integer range 0 to 255;
signal bus_tag_check : std_logic;
signal bus_addr_busy_q : std_logic;
signal bus_data_busy_q : std_logic;

signal mem_wr_en : std_logic;
signal mem_addr : std_logic_vector(0 to 7);
signal mem_wr_data : std_logic_vector(0 to 511);
signal mem_rd_data : std_logic_vector(0 to 511);

signal data_in_buf  : std_logic_vector(0 to 511) := (others => '0');

signal sel_mem_access : std_logic := '0'; -- 0 = processor, 1 = snooper

signal ll_bit : std_logic := '0';
signal ll_addr : std_logic_vector(0 to 11) := (others => '0');
signal sc_fail : std_logic;
begin

-----------------------------------------------------------------------------------
-- Processor side controller
-----------------------------------------------------------------------------------
-- Processor index for the state and tag table
proc_table_index <= to_integer(unsigned(proc_addr(4 to 11)));
-- Check to see if tag matches
proc_tag_check <= '1' when state_tag_table(proc_table_index).tag = proc_addr(0 to 3) else '0';

-- Address bus source ID always myself
p_sourceID <= std_logic_vector(to_unsigned(ID,2));

-- Address bus address always from processor request and current tag in table
p_addr <= state_tag_table(proc_table_index).tag & proc_addr(4 to 11);

-- Data bus data ID for flushing data in the case of an eviction
proc_dataID <= std_logic_vector(to_unsigned(ID,2));

-- Memory address for processor side access
proc_mem_addr <= proc_addr(4 to 11);

-- Processor side memory data to write
proc_mem_wr_data <= data_in_buf when not proc_mem_wr_src else
					mem_rd_data(0 to 383) & proc_wr_data when proc_addr(12 to 13)  = "11" else
					mem_rd_data(0 to 255) & proc_wr_data & mem_rd_data(384 to 511) when proc_addr(12 to 13)  = "10" else
					mem_rd_data(0 to 127) & proc_wr_data & mem_rd_data(256 to 511) when proc_addr(12 to 13)  = "01" else
					proc_wr_data & mem_rd_data(128 to 511);

-- Data to return to processor for reads
proc_rd_data <= (others => '0') when proc_sc and sc_fail else
				(31 => '1', others => '0') when proc_sc and not sc_fail else
				mem_rd_data(384 to 511) when proc_addr(12 to 13)  = "11" else
				mem_rd_data(256 to 383) when proc_addr(12 to 13)  = "10" else
				mem_rd_data(128 to 255) when proc_addr(12 to 13)  = "01" else
				mem_rd_data(0 to 127);

-- State machine to control processor requests to memory
process(clk)
begin
	if rising_edge(clk) then

		-- flip flop
		bus_addr_busy_q <= bus_addr_busy;

		-- default states
		proc_state_update <= '0';
		proc_tag_update <= '0';
		proc_mem_wr_en <= '0';
		proc_op_done <= '0';
		sc_fail <= '0';

		-- LL bit and LL addr
		if proc_rd and proc_ll then
			ll_bit <= '1';
			ll_addr <= proc_addr(0 to 11);
		elsif bus_addr_busy = '1' and bus_addr = ll_addr and
			(command_t'val(to_integer(unsigned(bus_cmd))) = BUS_RDX or
			command_t'val(to_integer(unsigned(bus_cmd))) = BUS_UPGR) then
			ll_bit <= '0';
		end if;

		-- Decide what to do with new processor requests
		-- if tag matches, cache hit
		if proc_tag_check then
			case state_tag_table(proc_table_index).state is
			-- if line is modified
			when modified_t =>
				-- if processor reads, cache hit
				if proc_rd or proc_rd_latch then
					proc_rd_latch <= '1';
					proc_mem_access <= '1';
					if sel_mem_access = '0' then
						proc_op_done <= '1';
						proc_rd_latch <= '0';
						proc_mem_access <= '0';
					end if;
				-- if processor writes, cache hit
				elsif proc_wr or proc_wr_latch then
					proc_wr_latch <= '1';
					proc_mem_access <= '1';
					if sel_mem_access = '0' then
						proc_op_done <= '1';
						proc_mem_wr_src <= '1';
						proc_mem_wr_en <= '1';
						proc_wr_latch <= '0';
						proc_mem_access <= '0';
						ll_bit <= '0' when proc_sc;
					end if;
				end if;
			-- if line is exclusive
			when exclusive_t =>
				-- if processor reads, cache hit
				if proc_rd or proc_rd_latch then
					proc_rd_latch <= '1';
					proc_mem_access <= '1';
					if sel_mem_access = '0' then
						proc_op_done <= '1';
						proc_rd_latch <= '0';
						proc_mem_access <= '0';
					end if;
				-- if processor writes, change state to modified
				elsif proc_wr or proc_wr_latch then
					proc_wr_latch <= '1';
					proc_mem_access <= '1';
					if sel_mem_access = '0' then
						proc_op_done <= '1';
						proc_mem_wr_src <= '1';
						proc_mem_wr_en <= '1';
						proc_state_new <= modified_t;
						proc_state_update <= '1';
						proc_wr_latch <= '0';
						proc_mem_access <= '0';
						ll_bit <= '0' when proc_sc;
					end if;
				end if;
			-- if line is shared
			when shared_t =>
				-- if processor reads, cache hit
				if proc_rd or proc_rd_latch then
					proc_rd_latch <= '1';
					proc_mem_access <= '1';
					if sel_mem_access = '0' then
						proc_op_done <= '1';
						proc_rd_latch <= '0';
						proc_mem_access <= '0';
					end if;
				-- if processor writes, initiate bus upgrade
				elsif proc_wr or proc_wr_latch then
					proc_wr_latch <= '1';
					proc_mem_access <= '1';
					if sel_mem_access = '0' then
						proc_wr_latch <= '0';
						if proc_sc and not ll_bit then
							sc_fail <= '1';
							proc_op_done <= '1';
							proc_mem_access <= '0';
						else
							init_bus_upgr <= '1';
						end if;
					end if;
				end if;
			-- if line is invalid
			when invalid_t =>
				-- if processor reads, initiate bus read
				if proc_rd or proc_rd_latch then
					proc_rd_latch <= '1';
					proc_mem_access <= '1';
					if sel_mem_access = '0' then
						proc_rd_latch <= '0';
						init_bus_rd <= '1';
					end if;
				-- if processor writes, initiate bus read exclusive
				elsif proc_wr or proc_wr_latch then
					proc_wr_latch <= '1';
					proc_mem_access <= '1';
					if sel_mem_access = '0' then
						proc_wr_latch <= '0';
						if proc_sc then
							sc_fail <= '1';
							proc_op_done <= '1';
							proc_mem_access <= '0';
						else
							init_bus_rdx <= '1';
						end if;
					end if;
				end if;
			end case;
		-- if tag does not match, cache miss, evict current line
		else
			-- if processor reads, initiate bus read
			if proc_rd or proc_rd_latch then
				proc_rd_latch <= '1';
				proc_mem_access <= '1';
				if sel_mem_access = '0' then
					proc_rd_latch <= '0';
					init_bus_rd <= '1';
					-- if line being evicted is modified, flush to memory
					if state_tag_table(proc_table_index).state = modified_t then
						init_flush <= '1';
					end if;
				end if;
			-- if processor writes, initiate bus read exclusive
			elsif proc_wr or proc_wr_latch then
				proc_wr_latch <= '1';
				proc_mem_access <= '1';
				if sel_mem_access = '0' then
					proc_wr_latch <= '0';
					init_bus_rdx <= '1';
					-- if line being evicted is modified, flush to memory
					if state_tag_table(proc_table_index).state = modified_t then
						init_flush <= '1';
					end if;
				end if;
			end if;
		end if;

		-- process requests, state machine
		-- if flushing a line being evicted
		if init_flush then
			if proc_state = 0 then
				p_addr_req <= '1';
				if p_addr_gnt then
					p_cmd <= std_logic_vector(to_unsigned(command_t'pos(FLUSH), 2));
					p_addr_req <= '0';
					proc_state <= 1;
				end if;
			elsif proc_state = 1 then
				proc_state <= 2;
			elsif proc_state = 2 then
				proc_state <= 3;
			elsif proc_state = 3 then
				proc_data_req <= '1';
				if proc_data_gnt then
					proc_data_req <= '0';
					proc_state <= 4;
				end if;
			elsif proc_state = 4 then
				proc_state <= 5;
			elsif proc_state = 5 then
				proc_state <= 0;
				init_flush <= '0';
			end if;
		-- if bus read operation
		elsif init_bus_rd then
			if proc_state = 0 then
				p_addr_req <= '1';
				proc_tag_update <= not proc_tag_check;
				if p_addr_gnt then
					p_cmd <= std_logic_vector(to_unsigned(command_t'pos(BUS_RD), 2));
					p_addr_req <= '0';
					proc_state <= 1;
				end if;
			elsif proc_state = 1 then
				proc_state <= 2;
			elsif proc_state = 2 then
				proc_state_new <= shared_t when bus_shared else exclusive_t;
				proc_state_update <= '1';
				proc_state <= 3;
			elsif proc_state = 3 then
				if bus_data_busy = '1' and bus_dataID = std_logic_vector(to_unsigned(ID,2)) then
					proc_state <= 4;
				end if;
			elsif proc_state = 4 then
				proc_state <= 5;
			elsif proc_state = 5 then
				proc_mem_wr_en <= '1';
				proc_mem_wr_src <= '0';
				proc_state <= 6;
			elsif proc_state = 6 then
				proc_op_done <= '1';
				proc_mem_access <= '0';
				init_bus_rd <= '0';
				proc_state <= 0;
			end if;
		-- if bus read exclusive operation
		elsif init_bus_rdx then
			if proc_state = 0 then
				p_addr_req <= '1';
				proc_tag_update <= not proc_tag_check;
				if p_addr_gnt then
					p_cmd <= std_logic_vector(to_unsigned(command_t'pos(BUS_RDX), 2));
					p_addr_req <= '0';
					proc_state <= 1;
				end if;
			elsif proc_state = 1 then
				proc_state <= 2;
			elsif proc_state = 2 then
				proc_state_new <= modified_t;
				proc_state_update <= '1';
				proc_state <= 3;
			elsif proc_state = 3 then
				if bus_data_busy = '1' and bus_dataID = std_logic_vector(to_unsigned(ID,2)) then
					proc_state <= 4;
				end if;
			elsif proc_state = 4 then
				proc_state <= 5;
			elsif proc_state = 5 then
				proc_mem_wr_en <= '1';
				proc_mem_wr_src <= '0';
				proc_state <= 6;
			elsif proc_state = 6 then
				proc_mem_wr_en <= '1';
				proc_mem_wr_src <= '1';
				proc_op_done <= '1';
				proc_mem_access <= '0';
				init_bus_rdx <= '0';
				proc_state <= 0;
			end if;
		-- if bus upgrade operation
		elsif init_bus_upgr then
			if proc_state = 0 then
				p_addr_req <= '1';
				proc_tag_update <= not proc_tag_check;
				if p_addr_gnt then
					p_cmd <= std_logic_vector(to_unsigned(command_t'pos(BUS_UPGR), 2));
					p_addr_req <= '0';
					proc_state <= 1;
					ll_bit <= '0' when proc_sc;
				-- another processor resets the load linked bit while I have a request
				elsif proc_sc and not ll_bit then
					sc_fail <= '1';
					p_addr_req <= '0';
					proc_op_done <= '1';
					proc_mem_access <= '0';
					init_bus_upgr <= '0';
					proc_state <= 0;
				end if;
			elsif proc_state = 1 then
				proc_state <= 2;
			elsif proc_state = 2 then
				proc_state_new <= modified_t;
				proc_state_update <= '1';
				if not bus_modified then
					proc_state <= 6;
				-- another processor modifies line just before I attempt to
				elsif proc_sc then
					sc_fail <= '1';
					proc_op_done <= '1';
					proc_mem_access <= '0';
					init_bus_upgr <= '0';
					proc_state <= 0;
				else
					proc_state <= 3;
				end if;
			elsif proc_state = 3 then
				if bus_data_busy = '1' and bus_dataID = std_logic_vector(to_unsigned(ID,2)) then
					proc_state <= 4;
				end if;
			elsif proc_state = 4 then
				proc_state <= 5;
			elsif proc_state = 5 then
				proc_mem_wr_en <= '1';
				proc_mem_wr_src <= '0';
				proc_state <= 6;
			elsif proc_state = 6 then
				proc_mem_wr_en <= '1';
				proc_mem_wr_src <= '1';
				proc_op_done <= '1';
				proc_mem_access <= '0';
				init_bus_upgr <= '0';
				proc_state <= 0;
			end if;
		end if;
	end if;
end process;

-- Data in buffer
process(clk)
begin
	if rising_edge(clk) then
		bus_data_busy_q <= bus_data_busy;
		if bus_data_busy then
			if bus_data_busy_q then
				data_in_buf(256 to 511) <= bus_data;
			else
				data_in_buf(0 to 255) <= bus_data;
			end if;
		end if;
	end if;
end process;

-----------------------------------------------------------------------------------
-- Bus side controller
-----------------------------------------------------------------------------------
-- Bus index for the state and tag table
bus_table_index <= to_integer(unsigned(bus_addr(4 to 11)));
-- Check to see if tag matches
bus_tag_check <= '1' when state_tag_table(bus_table_index).tag = bus_addr(0 to 3) else '0';

-- Memory address for bus side access
snoop_mem_addr <= request_table(to_integer(unsigned(snoop_dataID))).addr(4 to 11);

-- Address bus snooper, request table
process(clk)
begin
	if rising_edge(clk) then
		-- Default values
		snoop_state_update <= '0';

		-- Snoop address bus to fill request table
		if (bus_addr_busy and not bus_addr_busy_q) = '1' and to_integer(unsigned(bus_sourceID)) /= ID then
			if state_tag_table(to_integer(unsigned(bus_addr(4 to 11)))).state = modified_t or
			   state_tag_table(to_integer(unsigned(bus_addr(4 to 11)))).state = exclusive_t then
				request_table(to_integer(unsigned(bus_sourceID))) <= (bus_tag_check, bus_addr, bus_cmd, '1');
			else
				request_table(to_integer(unsigned(bus_sourceID))) <= (bus_tag_check, bus_addr, bus_cmd, '0');
			end if;
		end if;

		-- Check request table
		for i in request_table'range loop
			if request_table(i).valid then
				case command_t'val(to_integer(unsigned(request_table(i).bus_cmd))) is
				-- if snoop bus read
				when BUS_RD =>
					-- reply if line is modified or exclusive
					if request_table(i).response = '1' or
					   state_tag_table(to_integer(unsigned(request_table(i).addr(4 to 11)))).state = modified_t or
				   	   state_tag_table(to_integer(unsigned(request_table(i).addr(4 to 11)))).state = exclusive_t then
						if not response_busy then
							request_table(i).valid <= '0';
							snoop_dataID <= std_logic_vector(to_unsigned(i,2));
							response_busy <= '1';
							snoop_state_new <= shared_t;
							snoop_state_index <= to_integer(unsigned(request_table(i).addr(4 to 11)));
							--snoop_state_update <= '1';
						end if;
					else
						request_table(i).valid <= '0';
					end if;
				-- if snoop bus read exclusive
				when BUS_RDX =>
					-- reply if line is modified or exclusive
					if request_table(i).response = '1' or
					   state_tag_table(to_integer(unsigned(request_table(i).addr(4 to 11)))).state = modified_t or
				   	   state_tag_table(to_integer(unsigned(request_table(i).addr(4 to 11)))).state = exclusive_t then
						if not response_busy then
							request_table(i).valid <= '0';
							snoop_dataID <= std_logic_vector(to_unsigned(i,2));
							response_busy <= '1';
							snoop_state_new <= invalid_t;
							snoop_state_index <= to_integer(unsigned(request_table(i).addr(4 to 11)));
							--snoop_state_update <= '1';
						end if;
					else
						request_table(i).valid <= '0';
						if state_tag_table(to_integer(unsigned(request_table(i).addr(4 to 11)))).state = shared_t then
							snoop_state_new <= invalid_t;
							snoop_state_index <= to_integer(unsigned(request_table(i).addr(4 to 11)));
							snoop_state_update <= '1';
						end if;
					end if;
				-- if snoop bus upgrade
				when BUS_UPGR =>
					-- reply if line is modified
					if request_table(i).response = '1' or
					   state_tag_table(to_integer(unsigned(request_table(i).addr(4 to 11)))).state = modified_t then
						if not response_busy then
							request_table(i).valid <= '0';
							snoop_dataID <= std_logic_vector(to_unsigned(i,2));
							response_busy <= '1';
							snoop_state_new <= invalid_t;
							snoop_state_index <= to_integer(unsigned(request_table(i).addr(4 to 11)));
							--snoop_state_update <= '1';
						end if;
					else
						request_table(i).valid <= '0';
						if state_tag_table(to_integer(unsigned(request_table(i).addr(4 to 11)))).state = shared_t then
							snoop_state_new <= invalid_t;
							snoop_state_index <= to_integer(unsigned(request_table(i).addr(4 to 11)));
							snoop_state_update <= '1';
						end if;
					end if;
				-- if snoop flush operation, ignore
				when FLUSH =>
					request_table(i).valid <= '0';
				end case;
				exit;
			end if;
		end loop;

		-- response data state machine
		if response_busy then
			if response_state = 0 then
				snoop_data_req <= '1';
				snoop_mem_access <= '1';
				if snoop_data_gnt then
					snoop_data_req <= '0';
					response_state <= 1;
				end if;
			elsif response_state = 1 then
				response_state <= 2;
			elsif response_state = 2 then
				response_state <= 0;
				snoop_mem_access <= '0';
				response_busy <= '0';
				snoop_state_update <= '1';
			end if;
		end if;
	end if;
end process;

-- Drive modified and shared bus signals, one cycle latency
process(clk)
begin
	if rising_edge(clk) then
		if bus_sourceID /= std_logic_vector(to_unsigned(ID,2)) and bus_tag_check = '1' then
			with state_tag_table(bus_table_index).state select p_shared <= '1' when modified_t|exclusive_t|shared_t, '0' when others;
			with state_tag_table(bus_table_index).state select p_modified <= '1' when modified_t|exclusive_t, '0' when others;
		else
			p_shared <= '0';
			p_modified <= '0';
		end if;
	end if;
end process;

-- dual port state tag table
process(clk)
begin
	if rising_edge(clk) then
		if proc_tag_update then
			state_tag_table(proc_table_index).tag <= proc_addr(0 to 3);
		end if;
		if proc_state_update then
			state_tag_table(proc_table_index).state <= proc_state_new;
		end if;
		if snoop_state_update then
			state_tag_table(snoop_state_index).state <= snoop_state_new;
		end if;
	end if;
end process;

-- Data bus MUX select
process(clk)
begin
	if rising_edge(clk) then
		if sel_mem_access then
			if snoop_mem_access = '0' or (bus_data_busy = '1' and bus_dataID = std_logic_vector(to_unsigned(ID,2))) then
				sel_mem_access <= '0';
			end if;
		else
			if (proc_mem_access = '0' and proc_rd = '0' and proc_wr = '0') or (init_flush = '0' and proc_state = 3) then
				sel_mem_access <= snoop_mem_access;
			end if;
		end if;
	end if;
end process;

-- Data bus MUX
process(all)
begin
	case sel_mem_access is
	when '0' =>
		mem_addr <= proc_mem_addr;
		p_data_req <= proc_data_req;
		proc_data_gnt <= p_data_gnt;
		snoop_data_gnt <= '0';
		p_dataID <= proc_dataID;
	when '1' =>
		mem_addr <= snoop_mem_addr;
		p_data_req <= snoop_data_req;
		proc_data_gnt <= '0';
		snoop_data_gnt <= p_data_gnt;
		p_dataID <= snoop_dataID;
	when others => null;
	end case;
end process;

-- Data going to data bus
p_data <= mem_rd_data(0 to 255) when bus_data_busy and not bus_data_busy_q else mem_rd_data(256 to 511);

-- only processor writes data
mem_wr_en <= proc_mem_wr_en;
mem_wr_data <= proc_mem_wr_data;

-- 16kB L1 cache
L1_cache_inst : data_cache
generic map(
	LINE_SIZE_BYTES => 64,
	MEM_SIZE_KBYTES => 16,
	INIT => false
)
port map(
	clk => clk,
	wr_en => mem_wr_en,
	addr => mem_addr,
	wr_data => mem_wr_data,
	rd_data => mem_rd_data
);

end architecture;
