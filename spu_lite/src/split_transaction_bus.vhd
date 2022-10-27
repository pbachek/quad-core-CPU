library ieee;
use ieee.std_logic_1164.all;

entity split_transaction_bus is
	port (
	clk          	: in  std_logic;
	-- Address bus
	p0_addr_req     : in  std_logic;
	p0_addr_gnt     : out std_logic := '0';
	p0_addr        	: in  std_logic_vector(0 to 11);
	p0_sourceID    	: in  std_logic_vector(0 to 1);
	p0_cmd         	: in  std_logic_vector(0 to 1);
	p0_shared		: in  std_logic;
	p0_modified	 	: in  std_logic;
	p1_addr_req     : in  std_logic;
	p1_addr_gnt     : out std_logic := '0';
	p1_addr        	: in  std_logic_vector(0 to 11);
	p1_sourceID    	: in  std_logic_vector(0 to 1);
	p1_cmd         	: in  std_logic_vector(0 to 1);
	p1_shared		: in  std_logic;
	p1_modified	 	: in  std_logic;
	p2_addr_req     : in  std_logic;
	p2_addr_gnt     : out std_logic := '0';
	p2_addr        	: in  std_logic_vector(0 to 11);
	p2_sourceID    	: in  std_logic_vector(0 to 1);
	p2_cmd         	: in  std_logic_vector(0 to 1);
	p2_shared		: in  std_logic;
	p2_modified	 	: in  std_logic;
	p3_addr_req     : in  std_logic;
	p3_addr_gnt     : out std_logic := '0';
	p3_addr        	: in  std_logic_vector(0 to 11);
	p3_sourceID    	: in  std_logic_vector(0 to 1);
	p3_cmd         	: in  std_logic_vector(0 to 1);
	p3_shared		: in  std_logic;
	p3_modified	 	: in  std_logic;
	bus_addr_busy   : out std_logic := '0';
	bus_addr		: out std_logic_vector(0 to 11);
	bus_sourceID	: out std_logic_vector(0 to 1);
	bus_cmd			: out std_logic_vector(0 to 1);
	bus_shared		: out std_logic;
	bus_modified	: out std_logic;
	-- Data bus
	p0_data_req     : in  std_logic;
	p0_data_gnt     : out std_logic := '0';
	p0_data			: in  std_logic_vector(0 to 255);
	p0_dataID		: in  std_logic_vector(0 to 1);
	p1_data_req     : in  std_logic;
	p1_data_gnt     : out std_logic := '0';
	p1_data			: in  std_logic_vector(0 to 255);
	p1_dataID		: in  std_logic_vector(0 to 1);
	p2_data_req     : in  std_logic;
	p2_data_gnt     : out std_logic := '0';
	p2_data			: in  std_logic_vector(0 to 255);
	p2_dataID		: in  std_logic_vector(0 to 1);
	p3_data_req     : in  std_logic;
	p3_data_gnt     : out std_logic := '0';
	p3_data			: in  std_logic_vector(0 to 255);
	p3_dataID		: in  std_logic_vector(0 to 1);
	mem_data_req    : in  std_logic;
	mem_data_gnt    : out std_logic := '0';
	mem_data		: in  std_logic_vector(0 to 255);
	mem_dataID		: in  std_logic_vector(0 to 1);
	bus_data_busy   : out std_logic := '0';
	bus_data		: out std_logic_vector(0 to 255);
	bus_dataID		: out std_logic_vector(0 to 1)
	);
end entity;

architecture rtl of split_transaction_bus is

component arbiter is
generic(
	WIDTH : natural := 4
);
port(
	clk : in  std_logic;
	en  : in  std_logic;
	req : in  std_logic_vector(0 to WIDTH-1);
	gnt : out std_logic_vector(0 to WIDTH-1)
);
end component;

signal addr_bus_sel : std_logic_vector(1 downto 0) := 2x"0";
signal addr_bus_busy_cnt : integer range 0 to 2 := 0;

signal data_bus_sel : std_logic_vector(2 downto 0) := 3x"0";
signal data_bus_busy_cnt : integer range 0 to 2 := 0;

begin

-- Addr bus busy signal
process(clk)
begin
	if rising_edge(clk) then
		if p0_addr_gnt or p1_addr_gnt or p2_addr_gnt or p3_addr_gnt then
			bus_addr_busy <= '1';
			addr_bus_busy_cnt <= 1;
		elsif addr_bus_busy_cnt = 2 then
			bus_addr_busy <= '0';
			addr_bus_busy_cnt <= 0;
		elsif addr_bus_busy_cnt > 0 then
			addr_bus_busy_cnt <= addr_bus_busy_cnt + 1;
		end if;
	end if;
end process;

-- Addr bus MUX select
process(clk)
begin
	if rising_edge(clk) then
		if p0_addr_gnt then
			addr_bus_sel <= 2x"0";
		elsif p1_addr_gnt then
			addr_bus_sel <= 2x"1";
		elsif p2_addr_gnt then
			addr_bus_sel <= 2x"2";
		elsif p3_addr_gnt then
			addr_bus_sel <= 2x"3";
		end if;
	end if;
end process;

-- Address bus Arbiter
addr_bus_arbiter : arbiter
generic map(
	WIDTH => 4
)
port map(
	clk => clk,
	en => not bus_addr_busy,
	req(0) => p0_addr_req,
	req(1) => p1_addr_req,
	req(2) => p2_addr_req,
	req(3) => p3_addr_req,
	gnt(0) => p0_addr_gnt,
	gnt(1) => p1_addr_gnt,
	gnt(2) => p2_addr_gnt,
	gnt(3) => p3_addr_gnt
);

-- Wired OR
bus_shared <= p0_shared or p1_shared or p2_shared or p3_shared;
bus_modified <= p0_modified or p1_modified or p2_modified or p3_modified;

-- Address bus MUX
process(all)
begin
	case addr_bus_sel is
	when 2x"0" =>
		bus_addr		<= p0_addr;
		bus_sourceID	<= p0_sourceID;
		bus_cmd			<= p0_cmd;
	when 2x"1" =>
		bus_addr		<= p1_addr;
		bus_sourceID	<= p1_sourceID;
		bus_cmd			<= p1_cmd;
	when 2x"2" =>
		bus_addr		<= p2_addr;
		bus_sourceID	<= p2_sourceID;
		bus_cmd			<= p2_cmd;
	when 2x"3" =>
		bus_addr		<= p3_addr;
		bus_sourceID	<= p3_sourceID;
		bus_cmd			<= p3_cmd;
	when others => null;
	end case;
end process;

-- Data bus busy signal
process(clk)
begin
	if rising_edge(clk) then
		if p0_data_gnt or p1_data_gnt or p2_data_gnt or p3_data_gnt or mem_data_gnt then
			bus_data_busy <= '1';
			data_bus_busy_cnt <= 1;
		elsif data_bus_busy_cnt = 2 then
			bus_data_busy <= '0';
			data_bus_busy_cnt <= 0;
		elsif data_bus_busy_cnt > 0 then
			data_bus_busy_cnt <= data_bus_busy_cnt + 1;
		end if;
	end if;
end process;

-- Data bus MUX select
process(clk)
begin
	if rising_edge(clk) then
		if p0_data_gnt then
			data_bus_sel <= 3x"0";
		elsif p1_data_gnt then
			data_bus_sel <= 3x"1";
		elsif p2_data_gnt then
			data_bus_sel <= 3x"2";
		elsif p3_data_gnt then
			data_bus_sel <= 3x"3";
		elsif mem_data_gnt then
			data_bus_sel <= 3x"4";
		end if;
	end if;
end process;

-- Data bus Arbiter
data_bus_arbiter : arbiter
generic map(
	WIDTH => 5
)
port map(
	clk => clk,
	en => not bus_data_busy,
	req(0) => p0_data_req,
	req(1) => p1_data_req,
	req(2) => p2_data_req,
	req(3) => p3_data_req,
	req(4) => mem_data_req,
	gnt(0) => p0_data_gnt,
	gnt(1) => p1_data_gnt,
	gnt(2) => p2_data_gnt,
	gnt(3) => p3_data_gnt,
	gnt(4) => mem_data_gnt
);

-- Data bus MUX
process(all)
begin
	case data_bus_sel is
	when 3x"0" =>
		bus_data	<= p0_data;
		bus_dataID	<= p0_dataID;
	when 3x"1" =>
		bus_data	<= p1_data;
		bus_dataID	<= p1_dataID;
	when 3x"2" =>
		bus_data	<= p2_data;
		bus_dataID	<= p2_dataID;
	when 3x"3" =>
		bus_data	<= p3_data;
		bus_dataID	<= p3_dataID;
	when 3x"4" =>
		bus_data	<= mem_data;
		bus_dataID	<= mem_dataID;
	when others => null;
	end case;
end process;


end architecture;
