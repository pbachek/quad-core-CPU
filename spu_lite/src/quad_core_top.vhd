library ieee;
use ieee.std_logic_1164.all;

entity quad_core_top is
port(
	clk : in  std_logic
);
end entity;

architecture rtl of quad_core_top is

component split_transaction_bus is
	port (
	clk          	: in  std_logic;
	-- Address bus
	p0_addr_req     : in  std_logic;
	p0_addr_gnt     : out std_logic;
	p0_addr        	: in  std_logic_vector(0 to 11);
	p0_sourceID    	: in  std_logic_vector(0 to 1);
	p0_cmd         	: in  std_logic_vector(0 to 1);
	p0_shared		: in  std_logic;
	p0_modified	 	: in  std_logic;
	p1_addr_req     : in  std_logic;
	p1_addr_gnt     : out std_logic;
	p1_addr        	: in  std_logic_vector(0 to 11);
	p1_sourceID    	: in  std_logic_vector(0 to 1);
	p1_cmd         	: in  std_logic_vector(0 to 1);
	p1_shared		: in  std_logic;
	p1_modified	 	: in  std_logic;
	p2_addr_req     : in  std_logic;
	p2_addr_gnt     : out std_logic;
	p2_addr        	: in  std_logic_vector(0 to 11);
	p2_sourceID    	: in  std_logic_vector(0 to 1);
	p2_cmd         	: in  std_logic_vector(0 to 1);
	p2_shared		: in  std_logic;
	p2_modified	 	: in  std_logic;
	p3_addr_req     : in  std_logic;
	p3_addr_gnt     : out std_logic;
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
	p0_data_gnt     : out std_logic;
	p0_data			: in  std_logic_vector(0 to 255);
	p0_dataID		: in  std_logic_vector(0 to 1);
	p1_data_req     : in  std_logic;
	p1_data_gnt     : out std_logic;
	p1_data			: in  std_logic_vector(0 to 255);
	p1_dataID		: in  std_logic_vector(0 to 1);
	p2_data_req     : in  std_logic;
	p2_data_gnt     : out std_logic;
	p2_data			: in  std_logic_vector(0 to 255);
	p2_dataID		: in  std_logic_vector(0 to 1);
	p3_data_req     : in  std_logic;
	p3_data_gnt     : out std_logic;
	p3_data			: in  std_logic_vector(0 to 255);
	p3_dataID		: in  std_logic_vector(0 to 1);
	mem_data_req    : in  std_logic;
	mem_data_gnt    : out std_logic;
	mem_data		: in  std_logic_vector(0 to 255);
	mem_dataID		: in  std_logic_vector(0 to 1);
	bus_data_busy   : out std_logic := '0';
	bus_data		: out std_logic_vector(0 to 255);
	bus_dataID		: out std_logic_vector(0 to 1)
	);
end component;

component mem_controller is
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
end component;

component spu_lite is
generic(
	ID : natural := 0
);
port(
	clk 	 		: in  std_logic;
	-- Addr bus
	p_addr_req		: out std_logic;
	p_addr_gnt		: in  std_logic;
	p_addr			: out std_logic_vector(0 to 11);
	p_sourceID		: out std_logic_vector(0 to 1);
	p_cmd			: out std_logic_vector(0 to 1);
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
end component;

signal p0_addr_req     :  std_logic;
signal p0_addr_gnt     :  std_logic;
signal p0_addr        	:  std_logic_vector(0 to 11);
signal p0_sourceID    	:  std_logic_vector(0 to 1);
signal p0_cmd         	:  std_logic_vector(0 to 1);
signal p0_shared		:  std_logic;
signal p0_modified	 	:  std_logic;
signal p1_addr_req     :  std_logic;
signal p1_addr_gnt     :  std_logic;
signal p1_addr        	:  std_logic_vector(0 to 11);
signal p1_sourceID    	:  std_logic_vector(0 to 1);
signal p1_cmd         	:  std_logic_vector(0 to 1);
signal p1_shared		:  std_logic;
signal p1_modified	 	:  std_logic;
signal p2_addr_req     :  std_logic;
signal p2_addr_gnt     :  std_logic;
signal p2_addr        	:  std_logic_vector(0 to 11);
signal p2_sourceID    	:  std_logic_vector(0 to 1);
signal p2_cmd         	:  std_logic_vector(0 to 1);
signal p2_shared		:  std_logic;
signal p2_modified	 	:  std_logic;
signal p3_addr_req     :  std_logic;
signal p3_addr_gnt     :  std_logic;
signal p3_addr        	:  std_logic_vector(0 to 11);
signal p3_sourceID    	:  std_logic_vector(0 to 1);
signal p3_cmd         	:  std_logic_vector(0 to 1);
signal p3_shared		:  std_logic;
signal p3_modified	 	:  std_logic;
signal bus_addr_busy   :  std_logic := '0';
signal bus_addr		:  std_logic_vector(0 to 11);
signal bus_sourceID	:  std_logic_vector(0 to 1);
signal bus_cmd			:  std_logic_vector(0 to 1);
signal bus_shared		:  std_logic;
signal bus_modified	:  std_logic;
signal p0_data_req     :  std_logic;
signal p0_data_gnt     :  std_logic;
signal p0_data			:  std_logic_vector(0 to 255);
signal p0_dataID		:  std_logic_vector(0 to 1);
signal p1_data_req     :  std_logic;
signal p1_data_gnt     :  std_logic;
signal p1_data			:  std_logic_vector(0 to 255);
signal p1_dataID		:  std_logic_vector(0 to 1);
signal p2_data_req     :  std_logic;
signal p2_data_gnt     :  std_logic;
signal p2_data			:  std_logic_vector(0 to 255);
signal p2_dataID		:  std_logic_vector(0 to 1);
signal p3_data_req     :  std_logic;
signal p3_data_gnt     :  std_logic;
signal p3_data			:  std_logic_vector(0 to 255);
signal p3_dataID		:  std_logic_vector(0 to 1);
signal mem_data_req    :  std_logic;
signal mem_data_gnt    :  std_logic;
signal mem_data		:  std_logic_vector(0 to 255);
signal mem_dataID		:  std_logic_vector(0 to 1);
signal bus_data_busy   :  std_logic := '0';
signal bus_data		:  std_logic_vector(0 to 255);
signal bus_dataID		:  std_logic_vector(0 to 1);

begin

	split_transaction_bus_inst : split_transaction_bus
	port map(
		clk => clk,
		p0_addr_req => p0_addr_req,
		p0_addr_gnt => p0_addr_gnt,
		p0_addr => p0_addr,
		p0_sourceID => p0_sourceID,
		p0_cmd => p0_cmd,
		p0_shared => p0_shared,
		p0_modified => p0_modified,
		p1_addr_req => p1_addr_req,
		p1_addr_gnt => p1_addr_gnt,
		p1_addr => p1_addr,
		p1_sourceID => p1_sourceID,
		p1_cmd => p1_cmd,
		p1_shared => p1_shared,
		p1_modified => p1_modified,
		p2_addr_req => p2_addr_req,
		p2_addr_gnt => p2_addr_gnt,
		p2_addr => p2_addr,
		p2_sourceID => p2_sourceID,
		p2_cmd => p2_cmd,
		p2_shared => p2_shared,
		p2_modified => p2_modified,
		p3_addr_req => p3_addr_req,
		p3_addr_gnt => p3_addr_gnt,
		p3_addr => p3_addr,
		p3_sourceID => p3_sourceID,
		p3_cmd => p3_cmd,
		p3_shared => p3_shared,
		p3_modified => p3_modified,
		bus_addr_busy => bus_addr_busy,
		bus_addr => bus_addr,
		bus_sourceID => bus_sourceID,
		bus_cmd => bus_cmd,
		bus_shared => bus_shared,
		bus_modified => bus_modified,
		p0_data_req => p0_data_req,
		p0_data_gnt => p0_data_gnt,
		p0_data => p0_data,
		p0_dataID => p0_dataID,
		p1_data_req => p1_data_req,
		p1_data_gnt => p1_data_gnt,
		p1_data => p1_data,
		p1_dataID => p1_dataID,
		p2_data_req => p2_data_req,
		p2_data_gnt => p2_data_gnt,
		p2_data => p2_data,
		p2_dataID => p2_dataID,
		p3_data_req => p3_data_req,
		p3_data_gnt => p3_data_gnt,
		p3_data => p3_data,
		p3_dataID => p3_dataID,
		mem_data_req => mem_data_req,
		mem_data_gnt => mem_data_gnt,
		mem_data => mem_data,
		mem_dataID => mem_dataID,
		bus_data_busy => bus_data_busy,
		bus_data => bus_data,
		bus_dataID => bus_dataID
	);

	mem_controller_inst : mem_controller
	port map(
		clk => clk,
		bus_addr_busy => bus_addr_busy,
		bus_addr => bus_addr,
		bus_sourceID => bus_sourceID,
		bus_cmd => bus_cmd,
		bus_shared => bus_shared,
		bus_modified => bus_modified,
		mem_data_req => mem_data_req,
		mem_data_gnt => mem_data_gnt,
		mem_data => mem_data,
		mem_dataID => mem_dataID,
		bus_data_busy => bus_data_busy,
		bus_data => bus_data,
		bus_dataID => bus_dataID
	);

	core0 : spu_lite
	generic map(
		ID => 0
	)
	port map(
		clk => clk,
		p_addr_req => p0_addr_req,
		p_addr_gnt => p0_addr_gnt,
		p_addr => p0_addr,
		p_sourceID => p0_sourceID,
		p_cmd => p0_cmd,
		p_shared => p0_shared,
		p_modified => p0_modified,
		bus_addr_busy => bus_addr_busy,
		bus_addr => bus_addr,
		bus_sourceID => bus_sourceID,
		bus_cmd => bus_cmd,
		bus_shared => bus_shared,
		bus_modified => bus_modified,
		p_data_req => p0_data_req,
		p_data_gnt => p0_data_gnt,
		p_data => p0_data,
		p_dataID => p0_dataID,
		bus_data_busy => bus_data_busy,
		bus_data => bus_data,
		bus_dataID => bus_dataID
	);

	core1 : spu_lite
	generic map(
		ID => 1
	)
	port map(
		clk => clk,
		p_addr_req => p1_addr_req,
		p_addr_gnt => p1_addr_gnt,
		p_addr => p1_addr,
		p_sourceID => p1_sourceID,
		p_cmd => p1_cmd,
		p_shared => p1_shared,
		p_modified => p1_modified,
		bus_addr_busy => bus_addr_busy,
		bus_addr => bus_addr,
		bus_sourceID => bus_sourceID,
		bus_cmd => bus_cmd,
		bus_shared => bus_shared,
		bus_modified => bus_modified,
		p_data_req => p1_data_req,
		p_data_gnt => p1_data_gnt,
		p_data => p1_data,
		p_dataID => p1_dataID,
		bus_data_busy => bus_data_busy,
		bus_data => bus_data,
		bus_dataID => bus_dataID
	);

	core2 : spu_lite
	generic map(
		ID => 2
	)
	port map(
		clk => clk,
		p_addr_req => p2_addr_req,
		p_addr_gnt => p2_addr_gnt,
		p_addr => p2_addr,
		p_sourceID => p2_sourceID,
		p_cmd => p2_cmd,
		p_shared => p2_shared,
		p_modified => p2_modified,
		bus_addr_busy => bus_addr_busy,
		bus_addr => bus_addr,
		bus_sourceID => bus_sourceID,
		bus_cmd => bus_cmd,
		bus_shared => bus_shared,
		bus_modified => bus_modified,
		p_data_req => p2_data_req,
		p_data_gnt => p2_data_gnt,
		p_data => p2_data,
		p_dataID => p2_dataID,
		bus_data_busy => bus_data_busy,
		bus_data => bus_data,
		bus_dataID => bus_dataID
	);

	core3 : spu_lite
	generic map(
		ID => 3
	)
	port map(
		clk => clk,
		p_addr_req => p3_addr_req,
		p_addr_gnt => p3_addr_gnt,
		p_addr => p3_addr,
		p_sourceID => p3_sourceID,
		p_cmd => p3_cmd,
		p_shared => p3_shared,
		p_modified => p3_modified,
		bus_addr_busy => bus_addr_busy,
		bus_addr => bus_addr,
		bus_sourceID => bus_sourceID,
		bus_cmd => bus_cmd,
		bus_shared => bus_shared,
		bus_modified => bus_modified,
		p_data_req => p3_data_req,
		p_data_gnt => p3_data_gnt,
		p_data => p3_data,
		p_dataID => p3_dataID,
		bus_data_busy => bus_data_busy,
		bus_data => bus_data,
		bus_dataID => bus_dataID
	);

end architecture;
