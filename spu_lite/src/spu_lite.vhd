library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity spu_lite is
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
end entity;

architecture rtl of spu_lite is

component cache_controller is
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
	p_data_req  	: out std_logic := '0';
	p_data_gnt  	: in  std_logic;
	p_data			: out std_logic_vector(0 to 255);
	p_dataID		: out std_logic_vector(0 to 1) := 2x"0";
	bus_data_busy   : in  std_logic;
	bus_data		: in  std_logic_vector(0 to 255);
	bus_dataID		: in  std_logic_vector(0 to 1)
);
end component;
component branch_prediction_unit
  port (
       PCWr_BRU : in std_logic;
       PC_BRU : in std_logic_vector(0 to 31);
       PC_if : in std_logic_vector(0 to 31);
       clk : in std_logic;
       op_BRU_a : in std_logic_vector(0 to 2);
       op_BRU_rf : in std_logic_vector(0 to 2);
       PCWr : out std_logic;
       PC_br : out std_logic_vector(0 to 31);
       PC_o : out std_logic_vector(0 to 31);
       mispredict : out std_logic
  );
end component;
component branch_unit
  port (
       A : in std_logic_vector(0 to 127);
       Imm : in std_logic_vector(0 to 15);
       PC : in std_logic_vector(0 to 31);
       T : in std_logic_vector(0 to 127);
       op_sel : in std_logic_vector(0 to 2);
       PCWr : out std_logic;
       Result : out std_logic_vector(0 to 31)
  );
end component;
component byte_unit
  port (
       A : in std_logic_vector(0 to 127);
       B : in std_logic_vector(0 to 127);
       op_sel : in std_logic_vector(0 to 1);
       Result : out std_logic_vector(0 to 127)
  );
end component;
component decode_unit
  port (
       instruction : in std_logic_vector(0 to 31);
       Imm : out std_logic_vector(0 to 17);
       Latency : out std_logic_vector(0 to 2);
       RA : out std_logic_vector(0 to 6);
       RA_rd : out std_logic;
       RB : out std_logic_vector(0 to 6);
       RB_rd : out std_logic;
       RC : out std_logic_vector(0 to 6);
       RC_rd : out std_logic;
       RegDst : out std_logic_vector(0 to 6);
       RegWr : out std_logic;
       Unit : out std_logic_vector(0 to 2);
       op_BRU : out std_logic_vector(0 to 2);
       op_BU : out std_logic_vector(0 to 1);
       op_LSU : out std_logic_vector(0 to 3);
       op_PU : out std_logic_vector(0 to 1);
       op_SFU1 : out std_logic_vector(0 to 4);
       op_SFU2 : out std_logic_vector(0 to 2);
       op_SPU : out std_logic_vector(0 to 3);
       stop : out std_logic
  );
end component;
component forwarding_unit
  port (
       A_reg : in std_logic_vector(0 to 127);
       B_reg : in std_logic_vector(0 to 127);
       C_reg : in std_logic_vector(0 to 127);
       D_reg : in std_logic_vector(0 to 127);
       E_reg : in std_logic_vector(0 to 127);
       F_reg : in std_logic_vector(0 to 127);
       RA : in std_logic_vector(0 to 6);
       RB : in std_logic_vector(0 to 6);
       RC : in std_logic_vector(0 to 6);
       RD : in std_logic_vector(0 to 6);
       RE : in std_logic_vector(0 to 6);
       RF : in std_logic_vector(0 to 6);
       even2_RegDst : in std_logic_vector(0 to 6);
       even2_RegWr : in std_logic;
       even2_Result : in std_logic_vector(0 to 127);
       even3_RegDst : in std_logic_vector(0 to 6);
       even3_RegWr : in std_logic;
       even3_Result : in std_logic_vector(0 to 127);
       even4_RegDst : in std_logic_vector(0 to 6);
       even4_RegWr : in std_logic;
       even4_Result : in std_logic_vector(0 to 127);
       even5_RegDst : in std_logic_vector(0 to 6);
       even5_RegWr : in std_logic;
       even5_Result : in std_logic_vector(0 to 127);
       even6_RegDst : in std_logic_vector(0 to 6);
       even6_RegWr : in std_logic;
       even6_Result : in std_logic_vector(0 to 127);
       even7_RegDst : in std_logic_vector(0 to 6);
       even7_RegWr : in std_logic;
       even7_Result : in std_logic_vector(0 to 127);
       evenWB_RegDst : in std_logic_vector(0 to 6);
       evenWB_RegWr : in std_logic;
       evenWB_Result : in std_logic_vector(0 to 127);
       odd4_RegDst : in std_logic_vector(0 to 6);
       odd4_RegWr : in std_logic;
       odd4_Result : in std_logic_vector(0 to 127);
       odd5_RegDst : in std_logic_vector(0 to 6);
       odd5_RegWr : in std_logic;
       odd5_Result : in std_logic_vector(0 to 127);
       odd6_RegDst : in std_logic_vector(0 to 6);
       odd6_RegWr : in std_logic;
       odd6_Result : in std_logic_vector(0 to 127);
       odd7_RegDst : in std_logic_vector(0 to 6);
       odd7_RegWr : in std_logic;
       odd7_Result : in std_logic_vector(0 to 127);
       oddWB_RegDst : in std_logic_vector(0 to 6);
       oddWB_RegWr : in std_logic;
       oddWB_Result : in std_logic_vector(0 to 127);
       A : out std_logic_vector(0 to 127);
       B : out std_logic_vector(0 to 127);
       C : out std_logic_vector(0 to 127);
       D : out std_logic_vector(0 to 127);
       E : out std_logic_vector(0 to 127);
       F : out std_logic_vector(0 to 127)
  );
end component;
component instruction_cache
  port (
       PC : in std_logic_vector(0 to 31);
       clk : in std_logic;
       mem_data : in std_logic_vector(0 to 7);
       A_hit : out std_logic;
       A_instruction : out std_logic_vector(0 to 31);
       B_hit : out std_logic;
       B_instruction : out std_logic_vector(0 to 31);
       mem_addr : out std_logic_vector(0 to 31) := (others => '0')
  );
end component;
component instruction_memory
  generic(
       ID : natural := 0
  );
  port (
       addr : in std_logic_vector(0 to 31);
       data : out std_logic_vector(0 to 7)
  );
end component;
component issue_control_unit
  port (
       a_Imm : in std_logic_vector(0 to 17);
       a_Latency : in std_logic_vector(0 to 2);
       a_RA : in std_logic_vector(0 to 6);
       a_RA_rd : in std_logic;
       a_RB : in std_logic_vector(0 to 6);
       a_RB_rd : in std_logic;
       a_RC : in std_logic_vector(0 to 6);
       a_RC_rd : in std_logic;
       a_RegDst : in std_logic_vector(0 to 6);
       a_RegWr : in std_logic;
       a_Unit : in std_logic_vector(0 to 2);
       a_op_BRU : in std_logic_vector(0 to 2);
       a_op_BU : in std_logic_vector(0 to 1);
       a_op_LSU : in std_logic_vector(0 to 3);
       a_op_PU : in std_logic_vector(0 to 1);
       a_op_SFU1 : in std_logic_vector(0 to 4);
       a_op_SFU2 : in std_logic_vector(0 to 2);
       a_op_SPU : in std_logic_vector(0 to 3);
       a_stop : in std_logic;
       b_Imm : in std_logic_vector(0 to 17);
       b_Latency : in std_logic_vector(0 to 2);
       b_RA : in std_logic_vector(0 to 6);
       b_RA_rd : in std_logic;
       b_RB : in std_logic_vector(0 to 6);
       b_RB_rd : in std_logic;
       b_RC : in std_logic_vector(0 to 6);
       b_RC_rd : in std_logic;
       b_RegDst : in std_logic_vector(0 to 6);
       b_RegWr : in std_logic;
       b_Unit : in std_logic_vector(0 to 2);
       b_op_BRU : in std_logic_vector(0 to 2);
       b_op_BU : in std_logic_vector(0 to 1);
       b_op_LSU : in std_logic_vector(0 to 3);
       b_op_PU : in std_logic_vector(0 to 1);
       b_op_SFU1 : in std_logic_vector(0 to 4);
       b_op_SFU2 : in std_logic_vector(0 to 2);
       b_op_SPU : in std_logic_vector(0 to 3);
       b_stop : in std_logic;
       even0_Latency : in std_logic_vector(0 to 2);
       even0_RegDst : in std_logic_vector(0 to 6);
       even0_RegWr : in std_logic;
       even1_Latency : in std_logic_vector(0 to 2);
       even1_RegDst : in std_logic_vector(0 to 6);
       even1_RegWr : in std_logic;
       even2_Latency : in std_logic_vector(0 to 2);
       even2_RegDst : in std_logic_vector(0 to 6);
       even2_RegWr : in std_logic;
       even3_Latency : in std_logic_vector(0 to 2);
       even3_RegDst : in std_logic_vector(0 to 6);
       even3_RegWr : in std_logic;
       even4_Latency : in std_logic_vector(0 to 2);
       even4_RegDst : in std_logic_vector(0 to 6);
       even4_RegWr : in std_logic;
       even5_Latency : in std_logic_vector(0 to 2);
       even5_RegDst : in std_logic_vector(0 to 6);
       even5_RegWr : in std_logic;
       odd0_Latency : in std_logic_vector(0 to 2);
       odd0_RegDst : in std_logic_vector(0 to 6);
       odd0_RegWr : in std_logic;
       odd1_Latency : in std_logic_vector(0 to 2);
       odd1_RegDst : in std_logic_vector(0 to 6);
       odd1_RegWr : in std_logic;
       odd2_Latency : in std_logic_vector(0 to 2);
       odd2_RegDst : in std_logic_vector(0 to 6);
       odd2_RegWr : in std_logic;
       odd3_Latency : in std_logic_vector(0 to 2);
       odd3_RegDst : in std_logic_vector(0 to 6);
       odd3_RegWr : in std_logic;
       odd4_Latency : in std_logic_vector(0 to 2);
       odd4_RegDst : in std_logic_vector(0 to 6);
       odd4_RegWr : in std_logic;
       RA : out std_logic_vector(0 to 6);
       RB : out std_logic_vector(0 to 6);
       RC : out std_logic_vector(0 to 6);
       RD : out std_logic_vector(0 to 6);
       RE : out std_logic_vector(0 to 6);
       RF : out std_logic_vector(0 to 6);
       a_fetch : out std_logic;
       b_fetch : out std_logic;
       even_Imm : out std_logic_vector(0 to 17);
       even_Latency : out std_logic_vector(0 to 2);
       even_RegDst : out std_logic_vector(0 to 6);
       even_RegWr : out std_logic;
       even_Unit : out std_logic_vector(0 to 2);
       odd_Imm : out std_logic_vector(0 to 15);
       odd_Latency : out std_logic_vector(0 to 2);
       odd_RegDst : out std_logic_vector(0 to 6);
       odd_RegWr : out std_logic;
       odd_Unit : out std_logic_vector(0 to 2);
       op_BRU : out std_logic_vector(0 to 2);
       op_BU : out std_logic_vector(0 to 1);
       op_LSU : out std_logic_vector(0 to 3);
       op_PU : out std_logic_vector(0 to 1);
       op_SFU1 : out std_logic_vector(0 to 4);
       op_SFU2 : out std_logic_vector(0 to 2);
       op_SPU : out std_logic_vector(0 to 3)
  );
end component;
component mem_unit
port(
	clk : in std_logic;
	branch_mispredict : in std_logic;
	stall : out std_logic;
	mem_rd : out std_logic;
	mem_wr : out std_logic;
	op_done : in std_logic;
	mem_addr : out std_logic_vector(0 to 13);
	wr_data : out std_logic_vector(0 to 127);
	rd_data : in std_logic_vector(0 to 127);
	op_ll : out std_logic;
	op_sc : out std_logic;
	op_sel : in std_logic_vector(0 to 3);
	A : in std_logic_vector(0 to 127);
	B : in std_logic_vector(0 to 127);
	T : in std_logic_vector(0 to 127);
	Imm : in std_logic_vector(0 to 15);
	Result : out std_logic_vector(0 to 127)
);
end component;
component permute_unit
  port (
       A : in std_logic_vector(0 to 127);
       op_sel : in std_logic_vector(0 to 1);
       Result : out std_logic_vector(0 to 127)
  );
end component;
component program_counter
  port (
       PCWr : in std_logic;
       PC_i : in std_logic_vector(0 to 31);
       clk : in std_logic;
       en : in std_logic;
       inc2 : in std_logic;
       PC_o : out std_logic_vector(0 to 31)
  );
end component;
component register_file
  port (
       A_rd_addr : in std_logic_vector(0 to 6);
       A_wr_addr : in std_logic_vector(0 to 6);
       A_wr_data : in std_logic_vector(0 to 127);
       A_wr_en : in std_logic;
       B_rd_addr : in std_logic_vector(0 to 6);
       B_wr_addr : in std_logic_vector(0 to 6);
       B_wr_data : in std_logic_vector(0 to 127);
       B_wr_en : in std_logic;
       C_rd_addr : in std_logic_vector(0 to 6);
       D_rd_addr : in std_logic_vector(0 to 6);
       E_rd_addr : in std_logic_vector(0 to 6);
       F_rd_addr : in std_logic_vector(0 to 6);
       clk : in std_logic;
       A_rd_data : out std_logic_vector(0 to 127) := (others => '0');
       B_rd_data : out std_logic_vector(0 to 127) := (others => '0');
       C_rd_data : out std_logic_vector(0 to 127) := (others => '0');
       D_rd_data : out std_logic_vector(0 to 127) := (others => '0');
       E_rd_data : out std_logic_vector(0 to 127) := (others => '0');
       F_rd_data : out std_logic_vector(0 to 127) := (others => '0')
  );
end component;
component simple_fixed_unit1
  port (
       A : in std_logic_vector(0 to 127);
       B : in std_logic_vector(0 to 127);
       Imm : in std_logic_vector(0 to 17);
       op_sel : in std_logic_vector(0 to 4);
       Result : out std_logic_vector(0 to 127)
  );
end component;
component simple_fixed_unit2
  port (
       A : in std_logic_vector(0 to 127);
       B : in std_logic_vector(0 to 127);
       Imm : in std_logic_vector(0 to 17);
       op_sel : in std_logic_vector(0 to 2);
       Result : out std_logic_vector(0 to 127)
  );
end component;
component single_precision_unit
  port (
       A : in std_logic_vector(0 to 127);
       B : in std_logic_vector(0 to 127);
       C : in std_logic_vector(0 to 127);
       Imm : in std_logic_vector(0 to 17);
       op_sel : in std_logic_vector(0 to 3);
       Result : out std_logic_vector(0 to 127)
  );
end component;

---- Signal declarations used on the diagram ----

signal A_cache_hit : std_logic;
signal A_cache_hit_q : std_logic;
signal a_fetch : std_logic;
signal a_RA_rd : std_logic;
signal a_RB_rd : std_logic;
signal a_RC_rd : std_logic;
signal a_RegWr : std_logic;
signal a_stop : std_logic;
signal branch_mispredict : std_logic;
signal B_cache_hit : std_logic;
signal B_cache_hit_q : std_logic;
signal b_fetch : std_logic;
signal b_RA_rd : std_logic;
signal b_RB_rd : std_logic;
signal b_RC_rd : std_logic;
signal b_RegWr : std_logic;
signal b_stop : std_logic;
signal even0_RegWr : std_logic;
signal even1_RegWr : std_logic;
signal even2_RegWr : std_logic;
signal even3_RegWr : std_logic;
signal even4_RegWr : std_logic;
signal even5_RegWr : std_logic;
signal even6_RegWr : std_logic;
signal even7_RegWr : std_logic;
signal evenWB_RegWr : std_logic;
signal even_RegWr_rf : std_logic;
signal proc_ll : std_logic;
signal proc_sc : std_logic;
signal mem_stall : std_logic;
signal odd0_RegWr : std_logic;
signal odd1_RegWr : std_logic;
signal odd2_RegWr : std_logic;
signal odd3_RegWr : std_logic;
signal odd4_RegWr : std_logic;
signal odd5_RegWr : std_logic;
signal odd6_RegWr : std_logic;
signal odd7_RegWr : std_logic;
signal oddWB_RegWr : std_logic;
signal odd_RegWr_rf : std_logic;
signal PCWr : std_logic;
signal PCWr1 : std_logic;
signal PCWr_BRU : std_logic;
signal PC_en : std_logic;
signal PC_inc2 : std_logic;
signal proc_rd : std_logic;
signal proc_wr : std_logic;
signal proc_op_done : std_logic;
signal A : std_logic_vector(0 to 127);
signal a_Imm : std_logic_vector(0 to 17);
signal a_Latency : std_logic_vector(0 to 2);
signal a_op_BRU : std_logic_vector(0 to 2);
signal a_op_BU : std_logic_vector(0 to 1);
signal a_op_LSU : std_logic_vector(0 to 3);
signal a_op_PU : std_logic_vector(0 to 1);
signal a_op_SFU1 : std_logic_vector(0 to 4);
signal a_op_SFU2 : std_logic_vector(0 to 2);
signal a_op_SPU : std_logic_vector(0 to 3);
signal a_RA : std_logic_vector(0 to 6);
signal a_RB : std_logic_vector(0 to 6);
signal a_RC : std_logic_vector(0 to 6);
signal A_reg : std_logic_vector(0 to 127);
signal a_RegDst : std_logic_vector(0 to 6);
signal a_Unit : std_logic_vector(0 to 2);
signal B : std_logic_vector(0 to 127);
signal BU_Result : std_logic_vector(0 to 127);
signal BU_Result1 : std_logic_vector(0 to 127);
signal BU_Result2 : std_logic_vector(0 to 127);
signal BU_Result3 : std_logic_vector(0 to 127);
signal b_Imm : std_logic_vector(0 to 17);
signal b_Latency : std_logic_vector(0 to 2);
signal b_op_BRU : std_logic_vector(0 to 2);
signal b_op_BU : std_logic_vector(0 to 1);
signal b_op_LSU : std_logic_vector(0 to 3);
signal b_op_PU : std_logic_vector(0 to 1);
signal b_op_SFU1 : std_logic_vector(0 to 4);
signal b_op_SFU2 : std_logic_vector(0 to 2);
signal b_op_SPU : std_logic_vector(0 to 3);
signal b_RA : std_logic_vector(0 to 6);
signal b_RB : std_logic_vector(0 to 6);
signal b_RC : std_logic_vector(0 to 6);
signal B_reg : std_logic_vector(0 to 127);
signal b_RegDst : std_logic_vector(0 to 6);
signal b_Unit : std_logic_vector(0 to 2);
signal C : std_logic_vector(0 to 127);
signal C_reg : std_logic_vector(0 to 127);
signal D : std_logic_vector(0 to 127);
signal D_reg : std_logic_vector(0 to 127);
signal E : std_logic_vector(0 to 127);
signal even0_Latency : std_logic_vector(0 to 2);
signal even0_RegDst : std_logic_vector(0 to 6);
signal even0_Unit : std_logic_vector(0 to 2);
signal even1_Latency : std_logic_vector(0 to 2);
signal even1_RegDst : std_logic_vector(0 to 6);
signal even1_Result : std_logic_vector(0 to 127);
signal even1_Unit : std_logic_vector(0 to 2);
signal even2_Latency : std_logic_vector(0 to 2);
signal even2_RegDst : std_logic_vector(0 to 6);
signal even2_Result : std_logic_vector(0 to 127);
signal even2_Result_MUX : std_logic_vector(0 to 127);
signal even2_Unit : std_logic_vector(0 to 2);
signal even3_Latency : std_logic_vector(0 to 2);
signal even3_RegDst : std_logic_vector(0 to 6);
signal even3_Result : std_logic_vector(0 to 127);
signal even3_Result_MUX : std_logic_vector(0 to 127);
signal even3_Unit : std_logic_vector(0 to 2);
signal even4_Latency : std_logic_vector(0 to 2);
signal even4_RegDst : std_logic_vector(0 to 6);
signal even4_Result : std_logic_vector(0 to 127);
signal even4_Unit : std_logic_vector(0 to 2);
signal even5_Latency : std_logic_vector(0 to 2);
signal even5_RegDst : std_logic_vector(0 to 6);
signal even5_Result : std_logic_vector(0 to 127);
signal even5_Unit : std_logic_vector(0 to 2);
signal even6_Latency : std_logic_vector(0 to 2);
signal even6_RegDst : std_logic_vector(0 to 6);
signal even6_Result : std_logic_vector(0 to 127);
signal even6_Result_MUX : std_logic_vector(0 to 127);
signal even6_Unit : std_logic_vector(0 to 2);
signal even7_Latency : std_logic_vector(0 to 2);
signal even7_RegDst : std_logic_vector(0 to 6);
signal even7_Result : std_logic_vector(0 to 127);
signal even7_Result_MUX : std_logic_vector(0 to 127);
signal even7_Unit : std_logic_vector(0 to 2);
signal evenWB_Latency : std_logic_vector(0 to 2);
signal evenWB_RegDst : std_logic_vector(0 to 6);
signal evenWB_Result : std_logic_vector(0 to 127);
signal evenWB_Unit : std_logic_vector(0 to 2);
signal even_Imm : std_logic_vector(0 to 17);
signal even_Imm_rf : std_logic_vector(0 to 17);
signal even_Latency_rf : std_logic_vector(0 to 2);
signal even_RegDst_rf : std_logic_vector(0 to 6);
signal even_Unit_rf : std_logic_vector(0 to 2);
signal E_reg : std_logic_vector(0 to 127);
signal F : std_logic_vector(0 to 127);
signal F_reg : std_logic_vector(0 to 127);
signal instruction_A_dec : std_logic_vector(0 to 31);
signal instruction_A_if : std_logic_vector(0 to 31);
signal instruction_B_dec : std_logic_vector(0 to 31);
signal instruction_B_if : std_logic_vector(0 to 31);
signal instruction_mem_addr : std_logic_vector(0 to 31);
signal instruction_mem_data : std_logic_vector(0 to 7);
signal LSU_Result : std_logic_vector(0 to 127);
signal LSU_Result1 : std_logic_vector(0 to 127);
signal LSU_Result2 : std_logic_vector(0 to 127);
signal LSU_Result3 : std_logic_vector(0 to 127);
signal LSU_Result4 : std_logic_vector(0 to 127);
signal LSU_Result5 : std_logic_vector(0 to 127);
signal LSU_Result6 : std_logic_vector(0 to 127);
signal odd0_Latency : std_logic_vector(0 to 2);
signal odd0_RegDst : std_logic_vector(0 to 6);
signal odd0_Unit : std_logic_vector(0 to 2);
signal odd1_Latency : std_logic_vector(0 to 2);
signal odd1_RegDst : std_logic_vector(0 to 6);
signal odd1_Result : std_logic_vector(0 to 127);
signal odd1_Unit : std_logic_vector(0 to 2);
signal odd2_Latency : std_logic_vector(0 to 2);
signal odd2_RegDst : std_logic_vector(0 to 6);
signal odd2_Result : std_logic_vector(0 to 127);
signal odd2_Unit : std_logic_vector(0 to 2);
signal odd3_Latency : std_logic_vector(0 to 2);
signal odd3_RegDst : std_logic_vector(0 to 6);
signal odd3_Result : std_logic_vector(0 to 127);
signal odd3_Result_MUX : std_logic_vector(0 to 127);
signal odd3_Unit : std_logic_vector(0 to 2);
signal odd4_Latency : std_logic_vector(0 to 2);
signal odd4_RegDst : std_logic_vector(0 to 6);
signal odd4_Result : std_logic_vector(0 to 127);
signal odd4_Unit : std_logic_vector(0 to 2);
signal odd5_Latency : std_logic_vector(0 to 2);
signal odd5_RegDst : std_logic_vector(0 to 6);
signal odd5_Result : std_logic_vector(0 to 127);
signal odd5_Unit : std_logic_vector(0 to 2);
signal odd6_Latency : std_logic_vector(0 to 2);
signal odd6_RegDst : std_logic_vector(0 to 6);
signal odd6_Result : std_logic_vector(0 to 127);
signal odd6_Result_MUX : std_logic_vector(0 to 127);
signal odd6_Unit : std_logic_vector(0 to 2);
signal odd7_Latency : std_logic_vector(0 to 2);
signal odd7_RegDst : std_logic_vector(0 to 6);
signal odd7_Result : std_logic_vector(0 to 127);
signal odd7_Unit : std_logic_vector(0 to 2);
signal oddWB_Latency : std_logic_vector(0 to 2);
signal oddWB_RegDst : std_logic_vector(0 to 6);
signal oddWB_Result : std_logic_vector(0 to 127);
signal oddWB_Unit : std_logic_vector(0 to 2);
signal odd_Imm : std_logic_vector(0 to 15);
signal odd_Imm_rf : std_logic_vector(0 to 15);
signal odd_Latency_rf : std_logic_vector(0 to 2);
signal odd_RegDst_rf : std_logic_vector(0 to 6);
signal odd_Unit_rf : std_logic_vector(0 to 2);
signal op_BRU : std_logic_vector(0 to 2);
signal op_BRU_rf : std_logic_vector(0 to 2);
signal op_BU : std_logic_vector(0 to 1);
signal op_BU_rf : std_logic_vector(0 to 1);
signal op_LSU : std_logic_vector(0 to 3);
signal op_LSU_rf : std_logic_vector(0 to 3);
signal op_PU : std_logic_vector(0 to 1);
signal op_PU_rf : std_logic_vector(0 to 1);
signal op_SFU1 : std_logic_vector(0 to 4);
signal op_SFU1_rf : std_logic_vector(0 to 4);
signal op_SFU2 : std_logic_vector(0 to 2);
signal op_SFU2_rf : std_logic_vector(0 to 2);
signal op_SPU : std_logic_vector(0 to 3);
signal op_SPU_rf : std_logic_vector(0 to 3);
signal PC_BRU : std_logic_vector(0 to 31);
signal PC_BRU1 : std_logic_vector(0 to 31);
signal PC_d : std_logic_vector(0 to 31);
signal PC_fw : std_logic_vector(0 to 31);
signal PC_if : std_logic_vector(0 to 31);
signal PC_rf : std_logic_vector(0 to 31);
signal PU_Result : std_logic_vector(0 to 127);
signal PU_Result1 : std_logic_vector(0 to 127);
signal PU_Result2 : std_logic_vector(0 to 127);
signal PU_Result3 : std_logic_vector(0 to 127);
signal proc_addr : std_logic_vector(0 to 13);
signal proc_wr_data : std_logic_vector(0 to 127);
signal proc_rd_data : std_logic_vector(0 to 127);
signal RA_fw : std_logic_vector(0 to 6);
signal RA_rf : std_logic_vector(0 to 6);
signal RB_fw : std_logic_vector(0 to 6);
signal RB_rf : std_logic_vector(0 to 6);
signal RC_fw : std_logic_vector(0 to 6);
signal RC_rf : std_logic_vector(0 to 6);
signal RD_fw : std_logic_vector(0 to 6);
signal RD_rf : std_logic_vector(0 to 6);
signal RE_fw : std_logic_vector(0 to 6);
signal RE_rf : std_logic_vector(0 to 6);
signal RF_fw : std_logic_vector(0 to 6);
signal RF_rf : std_logic_vector(0 to 6);
signal SFU1_Result : std_logic_vector(0 to 127);
signal SFU1_Result1 : std_logic_vector(0 to 127);
signal SFU1_Result2 : std_logic_vector(0 to 127);
signal SFU2_Result : std_logic_vector(0 to 127);
signal SFU2_Result1 : std_logic_vector(0 to 127);
signal SFU2_Result2 : std_logic_vector(0 to 127);
signal SFU2_Result3 : std_logic_vector(0 to 127);
signal SPU_Result : std_logic_vector(0 to 127);
signal SPU_Result1 : std_logic_vector(0 to 127);
signal SPU_Result2 : std_logic_vector(0 to 127);
signal SPU_Result3 : std_logic_vector(0 to 127);
signal SPU_Result4 : std_logic_vector(0 to 127);
signal SPU_Result5 : std_logic_vector(0 to 127);
signal SPU_Result6 : std_logic_vector(0 to 127);
signal SPU_Result7 : std_logic_vector(0 to 127);

begin

-- Program counter control signals
PC_en <= A_cache_hit_q and a_fetch and not mem_stall;
PC_inc2 <= B_cache_hit_q and b_fetch;

-- Pipeline result MUXes
even2_Result_MUX <= SFU1_Result2 when unit_t'val(to_integer(unsigned(even2_Unit))) = UNIT_SIMPLE_FIXED1 else even2_Result;
even3_Result_MUX <= BU_Result3 when unit_t'val(to_integer(unsigned(even3_Unit))) = UNIT_BYTE else SFU2_Result3 when unit_t'val(to_integer(unsigned(even3_Unit))) = UNIT_SIMPLE_FIXED2 else even3_Result;
even6_Result_MUX <= SPU_Result6 when unit_t'val(to_integer(unsigned(even6_Unit))) = UNIT_SINGLE_PRECISION and to_integer(unsigned(even6_Latency)) = 6 else even6_Result;
even7_Result_MUX <= SPU_Result7 when unit_t'val(to_integer(unsigned(even7_Unit))) = UNIT_SINGLE_PRECISION and to_integer(unsigned(even7_Latency)) = 7 else even7_Result;
odd3_Result_MUX <= PU_Result3 when unit_t'val(to_integer(unsigned(odd3_Unit))) = UNIT_PERMUTE else odd3_Result;
odd6_Result_MUX <= LSU_Result6 when unit_t'val(to_integer(unsigned(odd6_Unit))) = UNIT_LOCAL_STORE else odd6_Result;

process(clk)
begin
	if rising_edge(clk) then
		-- Registers
		A_cache_hit_q <= A_cache_hit;
		B_cache_hit_q <= B_cache_hit;
		-- Decode registers
        instruction_A_dec <= (others => '0') when not A_cache_hit else instruction_A_if;
        instruction_B_dec <= (others => '0') when A_cache_hit nand B_cache_hit else instruction_B_if;
		-- Register fetch registers
		-- Even pipe
		if branch_mispredict or mem_stall then
			even_Imm <= (others => '0');
			even0_Latency <= (others => '0');
			RA_fw <= (others => '0');
			RB_fw <= (others => '0');
			RC_fw <= (others => '0');
			even0_RegDst <= (others => '0');
			even0_RegWr <= '0';
			even0_Unit <= (others => '0');
			op_BU <= (others => '0');
			op_SFU1 <= (others => '0');
			op_SFU2 <= (others => '0');
			op_SPU <= (others => '0');
		else
			even_Imm <= even_Imm_rf;
			even0_Latency <= even_Latency_rf;
			RA_fw <= RA_rf;
			RB_fw <= RB_rf;
			RC_fw <= RC_rf;
			even0_RegDst <= even_RegDst_rf;
			even0_RegWr <= even_RegWr_rf;
			even0_Unit <= even_Unit_rf;
			op_BU <= op_BU_rf;
			op_SFU1 <= op_SFU1_rf;
			op_SFU2 <= op_SFU2_rf;
			op_SPU <= op_SPU_rf;
		end if;
		-- Odd pipe
		if branch_mispredict then
			odd_Imm <= (others => '0');
			odd0_Latency <= (others => '0');
			PC_fw <= (others => '0');
			RD_fw <= (others => '0');
			RE_fw <= (others => '0');
			RF_fw <= (others => '0');
			odd0_RegDst <= (others => '0');
			odd0_RegWr <= '0';
			odd0_Unit <= (others => '0');
			op_BRU <= (others => '0');
			op_LSU <= (others => '0');
			op_PU <= (others => '0');
		elsif not mem_stall then
			odd_Imm <= odd_Imm_rf;
			odd0_Latency <= odd_Latency_rf;
			PC_fw <= PC_rf;
			RD_fw <= RD_rf;
			RE_fw <= RE_rf;
			RF_fw <= RF_rf;
			odd0_RegDst <= odd_RegDst_rf;
			odd0_RegWr <= odd_RegWr_rf;
			odd0_Unit <= odd_Unit_rf;
			op_BRU <= op_BRU_rf;
			op_LSU <= op_LSU_rf;
			op_PU <= op_PU_rf;
		end if;
		-- Even pipeline registers
		if branch_mispredict then
			even1_Latency 	<= (others => '0');
			even1_RegDst 	<= (others => '0');
			even1_RegWr 	<= '0';
			even1_Unit 		<= (others => '0');
		else
			even1_Latency 	<= even0_Latency;
			even1_RegDst 	<= even0_RegDst;
			even1_RegWr 	<= even0_RegWr;
			even1_Unit 		<= even0_Unit;
		end if;
		even1_Result 	<= (others => '0');
		even2_Latency 	<= even1_Latency;
		even2_RegDst 	<= even1_RegDst;
		even2_RegWr 	<= even1_RegWr;
		even2_Result 	<= even1_Result;
		even2_Unit 		<= even1_Unit;
		even3_Latency 	<= even2_Latency;
		even3_RegDst 	<= even2_RegDst;
		even3_RegWr 	<= even2_RegWr;
		even3_Result 	<= even2_Result_MUX;
		even3_Unit 		<= even2_Unit;
		even4_Latency 	<= even3_Latency;
		even4_RegDst 	<= even3_RegDst;
		even4_RegWr 	<= even3_RegWr;
		even4_Result 	<= even3_Result_MUX;
		even4_Unit 		<= even3_Unit;
		even5_Latency 	<= even4_Latency;
		even5_RegDst 	<= even4_RegDst;
		even5_RegWr 	<= even4_RegWr;
		even5_Result 	<= even4_Result;
		even5_Unit 		<= even4_Unit;
		even6_Latency 	<= even5_Latency;
		even6_RegDst 	<= even5_RegDst;
		even6_RegWr 	<= even5_RegWr;
		even6_Result 	<= even5_Result;
		even6_Unit 		<= even5_Unit;
		even7_Latency 	<= even6_Latency;
		even7_RegDst 	<= even6_RegDst;
		even7_RegWr 	<= even6_RegWr;
		even7_Result 	<= even6_Result_MUX;
		even7_Unit 		<= even6_Unit;
		evenWB_Latency 	<= even7_Latency;
		evenWB_RegDst 	<= even7_RegDst;
		evenWB_RegWr 	<= even7_RegWr;
		evenWB_Result 	<= even7_Result_MUX;
		evenWB_Unit 	<= even7_Unit;
		-- Odd pipeline registers
		if branch_mispredict or mem_stall then
			odd1_Latency	<= (others => '0');
			odd1_RegDst		<= (others => '0');
			odd1_RegWr		<= '0';
			odd1_Unit		<= (others => '0');
		else
			odd1_Latency	<= odd0_Latency;
			odd1_RegDst		<= odd0_RegDst;
			odd1_RegWr		<= odd0_RegWr;
			odd1_Unit		<= odd0_Unit;
		end if;
		odd1_Result		<= (others => '0');
		odd2_Latency	<= odd1_Latency;
		odd2_RegDst		<= odd1_RegDst;
		odd2_RegWr		<= odd1_RegWr;
		odd2_Result		<= odd1_Result;
		odd2_Unit		<= odd1_Unit;
		odd3_Latency	<= odd2_Latency;
		odd3_RegDst		<= odd2_RegDst;
		odd3_RegWr		<= odd2_RegWr;
		odd3_Result		<= odd2_Result;
		odd3_Unit		<= odd2_Unit;
		odd4_Latency	<= odd3_Latency;
		odd4_RegDst		<= odd3_RegDst;
		odd4_RegWr		<= odd3_RegWr;
		odd4_Result		<= odd3_Result_MUX;
		odd4_Unit		<= odd3_Unit;
		odd5_Latency	<= odd4_Latency;
		odd5_RegDst		<= odd4_RegDst;
		odd5_RegWr		<= odd4_RegWr;
		odd5_Result		<= odd4_Result;
		odd5_Unit		<= odd4_Unit;
		odd6_Latency	<= odd5_Latency;
		odd6_RegDst		<= odd5_RegDst;
		odd6_RegWr		<= odd5_RegWr;
		odd6_Result		<= odd5_Result;
		odd6_Unit		<= odd5_Unit;
		odd7_Latency	<= odd6_Latency;
		odd7_RegDst		<= odd6_RegDst;
		odd7_RegWr		<= odd6_RegWr;
		odd7_Result		<= odd6_Result_MUX;
		odd7_Unit		<= odd6_Unit;
		oddWB_Latency	<= odd7_Latency;
		oddWB_RegDst	<= odd7_RegDst;
		oddWB_RegWr		<= odd7_RegWr;
		oddWB_Result	<= odd7_Result;
		oddWB_Unit		<= odd7_Unit;
		-- Permute unit pipeline registers
		PU_Result1 <= PU_Result;
		PU_Result2 <= PU_Result1;
		PU_Result3 <= PU_Result2;
		-- Simple Fixed unit 1 pipeline registers
		SFU1_Result1 <= SFU1_Result;
		SFU1_Result2 <= SFU1_Result1;
		-- Simple Fixed unit 2 pipeline registers
		SFU2_Result1 <= SFU2_Result;
		SFU2_Result2 <= SFU2_Result1;
		SFU2_Result3 <= SFU2_Result2;
		-- Single Precision unit pipeline registers
		SPU_Result1 <= SPU_Result;
		SPU_Result2 <= SPU_Result1;
		SPU_Result3 <= SPU_Result2;
		SPU_Result4 <= SPU_Result3;
		SPU_Result5 <= SPU_Result4;
		SPU_Result6 <= SPU_Result5;
		SPU_Result7 <= SPU_Result6;
		-- Branch unit pipeline registers
		PCWr1 <= PCWr_BRU;
		PC_BRU1 <= PC_BRU;
		-- Byte unit pipeline registers
		BU_Result1 <= BU_result;
		BU_Result2 <= BU_Result1;
		BU_Result3 <= BU_Result2;
		-- Local store unit pipeline registers
		LSU_Result1 <= LSU_Result;
		LSU_Result2 <= LSU_Result1;
		LSU_Result3 <= LSU_Result2;
		LSU_Result4 <= LSU_Result3;
		LSU_Result5 <= LSU_Result4;
		LSU_Result6 <= LSU_Result5;

	end if;
end process;

BRU : branch_unit
  port map(
       A => D,
       Imm => odd_Imm,
       PC => PC_fw,
       PCWr => PCWr_BRU,
       Result => PC_BRU,
       T => F,
       op_sel => op_BRU
  );

BU : byte_unit
  port map(
       A => A,
       B => B,
       Result => BU_Result,
       op_sel => op_BU
  );

Branch_prediction : branch_prediction_unit
  port map(
       PCWr => PCWr,
       PCWr_BRU => PCWr1,
       PC_BRU => PC_BRU1,
       PC_br => PC_rf,
       PC_if => PC_if,
       PC_o => PC_d,
       clk => clk,
       mispredict => branch_mispredict,
       op_BRU_a => a_op_BRU,
       op_BRU_rf => op_BRU_rf
  );

Decode_A : decode_unit
  port map(
       Imm => a_Imm,
       Latency => a_Latency,
       RA => a_RA,
       RA_rd => a_RA_rd,
       RB => a_RB,
       RB_rd => a_RB_rd,
       RC => a_RC,
       RC_rd => a_RC_rd,
       RegDst => a_RegDst,
       RegWr => a_RegWr,
       Unit => a_Unit,
       instruction => instruction_A_dec,
       op_BRU => a_op_BRU,
       op_BU => a_op_BU,
       op_LSU => a_op_LSU,
       op_PU => a_op_PU,
       op_SFU1 => a_op_SFU1,
       op_SFU2 => a_op_SFU2,
       op_SPU => a_op_SPU,
       stop => a_stop
  );

Decode_B : decode_unit
  port map(
       Imm => b_Imm,
       Latency => b_Latency,
       RA => b_RA,
       RA_rd => b_RA_rd,
       RB => b_RB,
       RB_rd => b_RB_rd,
       RC => b_RC,
       RC_rd => b_RC_rd,
       RegDst => b_RegDst,
       RegWr => b_RegWr,
       Unit => b_Unit,
       instruction => instruction_B_dec,
       op_BRU => b_op_BRU,
       op_BU => b_op_BU,
       op_LSU => b_op_LSU,
       op_PU => b_op_PU,
       op_SFU1 => b_op_SFU1,
       op_SFU2 => b_op_SFU2,
       op_SPU => b_op_SPU,
       stop => b_stop
  );

FWD_Unit : forwarding_unit
  port map(
       A => A,
       A_reg => A_reg,
       B => B,
       B_reg => B_reg,
       C => C,
       C_reg => C_reg,
       D => D,
       D_reg => D_reg,
       E => E,
       E_reg => E_reg,
       F => F,
       F_reg => F_reg,
       RA => RA_fw,
       RB => RB_fw,
       RC => RC_fw,
       RD => RD_fw,
       RE => RE_fw,
       RF => RF_fw,
       even2_RegDst => even2_RegDst,
       even2_RegWr => even2_RegWr,
       even2_Result => even2_Result_MUX,
       even3_RegDst => even3_RegDst,
       even3_RegWr => even3_RegWr,
       even3_Result => even3_Result,
       even4_RegDst => even4_RegDst,
       even4_RegWr => even4_RegWr,
       even4_Result => even4_Result,
       even5_RegDst => even5_RegDst,
       even5_RegWr => even5_RegWr,
       even5_Result => even5_Result,
       even6_RegDst => even6_RegDst,
       even6_RegWr => even6_RegWr,
       even6_Result => even6_Result_MUX,
       even7_RegDst => even7_RegDst,
       even7_RegWr => even7_RegWr,
       even7_Result => even7_Result_MUX,
       evenWB_RegDst => evenWB_RegDst,
       evenWB_RegWr => evenWB_RegWr,
       evenWB_Result => evenWB_Result,
       odd4_RegDst => odd4_RegDst,
       odd4_RegWr => odd4_RegWr,
       odd4_Result => odd4_Result,
       odd5_RegDst => odd5_RegDst,
       odd5_RegWr => odd5_RegWr,
       odd5_Result => odd5_Result,
       odd6_RegDst => odd6_RegDst,
       odd6_RegWr => odd6_RegWr,
       odd6_Result => odd6_Result_MUX,
       odd7_RegDst => odd7_RegDst,
       odd7_RegWr => odd7_RegWr,
       odd7_Result => odd7_Result,
       oddWB_RegDst => oddWB_RegDst,
       oddWB_RegWr => oddWB_RegWr,
       oddWB_Result => oddWB_Result
  );

I_cache : instruction_cache
  port map(
       A_hit => A_cache_hit,
       A_instruction => instruction_A_if,
       B_hit => B_cache_hit,
       B_instruction => instruction_B_if,
       PC => PC_if,
       clk => clk,
       mem_addr => instruction_mem_addr,
       mem_data => instruction_mem_data
  );

Instruction_mem : instruction_memory
  generic map(
       ID => ID
  )
  port map(
       addr => instruction_mem_addr,
       data => instruction_mem_data
  );

Issue_control : issue_control_unit
  port map(
       RA => RA_rf,
       RB => RB_rf,
       RC => RC_rf,
       RD => RD_rf,
       RE => RE_rf,
       RF => RF_rf,
       a_Imm => a_Imm,
       a_Latency => a_Latency,
       a_RA => a_RA,
       a_RA_rd => a_RA_rd,
       a_RB => a_RB,
       a_RB_rd => a_RB_rd,
       a_RC => a_RC,
       a_RC_rd => a_RC_rd,
       a_RegDst => a_RegDst,
       a_RegWr => a_RegWr,
       a_Unit => a_Unit,
       a_fetch => a_fetch,
       a_op_BRU => a_op_BRU,
       a_op_BU => a_op_BU,
       a_op_LSU => a_op_LSU,
       a_op_PU => a_op_PU,
       a_op_SFU1 => a_op_SFU1,
       a_op_SFU2 => a_op_SFU2,
       a_op_SPU => a_op_SPU,
       a_stop => a_stop,
       b_Imm => b_Imm,
       b_Latency => b_Latency,
       b_RA => b_RA,
       b_RA_rd => b_RA_rd,
       b_RB => b_RB,
       b_RB_rd => b_RB_rd,
       b_RC => b_RC,
       b_RC_rd => b_RC_rd,
       b_RegDst => b_RegDst,
       b_RegWr => b_RegWr,
       b_Unit => b_Unit,
       b_fetch => b_fetch,
       b_op_BRU => b_op_BRU,
       b_op_BU => b_op_BU,
       b_op_LSU => b_op_LSU,
       b_op_PU => b_op_PU,
       b_op_SFU1 => b_op_SFU1,
       b_op_SFU2 => b_op_SFU2,
       b_op_SPU => b_op_SPU,
       b_stop => b_stop,
       even0_Latency => even0_Latency,
       even0_RegDst => even0_RegDst,
       even0_RegWr => even0_RegWr,
       even1_Latency => even1_Latency,
       even1_RegDst => even1_RegDst,
       even1_RegWr => even1_RegWr,
       even2_Latency => even2_Latency,
       even2_RegDst => even2_RegDst,
       even2_RegWr => even2_RegWr,
       even3_Latency => even3_Latency,
       even3_RegDst => even3_RegDst,
       even3_RegWr => even3_RegWr,
       even4_Latency => even4_Latency,
       even4_RegDst => even4_RegDst,
       even4_RegWr => even4_RegWr,
       even5_Latency => even5_Latency,
       even5_RegDst => even5_RegDst,
       even5_RegWr => even5_RegWr,
       even_Imm => even_Imm_rf,
       even_Latency => even_Latency_rf,
       even_RegDst => even_RegDst_rf,
       even_RegWr => even_RegWr_rf,
       even_Unit => even_Unit_rf,
       odd0_Latency => odd0_Latency,
       odd0_RegDst => odd0_RegDst,
       odd0_RegWr => odd0_RegWr,
       odd1_Latency => odd1_Latency,
       odd1_RegDst => odd1_RegDst,
       odd1_RegWr => odd1_RegWr,
       odd2_Latency => odd2_Latency,
       odd2_RegDst => odd2_RegDst,
       odd2_RegWr => odd2_RegWr,
       odd3_Latency => odd3_Latency,
       odd3_RegDst => odd3_RegDst,
       odd3_RegWr => odd3_RegWr,
       odd4_Latency => odd4_Latency,
       odd4_RegDst => odd4_RegDst,
       odd4_RegWr => odd4_RegWr,
       odd_Imm => odd_Imm_rf,
       odd_Latency => odd_Latency_rf,
       odd_RegDst => odd_RegDst_rf,
       odd_RegWr => odd_RegWr_rf,
       odd_Unit => odd_Unit_rf,
       op_BRU => op_BRU_rf,
       op_BU => op_BU_rf,
       op_LSU => op_LSU_rf,
       op_PU => op_PU_rf,
       op_SFU1 => op_SFU1_rf,
       op_SFU2 => op_SFU2_rf,
       op_SPU => op_SPU_rf
  );

LSU_mem_unit : mem_unit
  port map(
       clk => clk,
       branch_mispredict => branch_mispredict,
       stall => mem_stall,
       mem_rd => proc_rd,
       mem_wr => proc_wr,
       op_done => proc_op_done,
       mem_addr => proc_addr,
       wr_data => proc_wr_data,
       rd_data => proc_rd_data,
	   op_ll => proc_ll,
	   op_sc => proc_sc,
       op_sel => op_LSU,
       A => D,
       B => E,
       T => F,
       Imm => odd_Imm,
       Result => LSU_Result
  );

cache_controller_inst : cache_controller
	generic map(
		ID => ID
	)
	port map(
		clk => clk,
		proc_rd => proc_rd,
		proc_wr => proc_wr,
		proc_op_done => proc_op_done,
		proc_addr => proc_addr,
		proc_wr_data => proc_wr_data,
		proc_rd_data => proc_rd_data,
		proc_ll => proc_ll,
		proc_sc => proc_sc,
		p_addr_req => p_addr_req,
		p_addr_gnt => p_addr_gnt,
		p_addr => p_addr,
		p_sourceID => p_sourceID,
		p_cmd => p_cmd,
		p_shared => p_shared,
		p_modified => p_modified,
		bus_addr_busy => bus_addr_busy,
		bus_addr => bus_addr,
		bus_sourceID => bus_sourceID,
		bus_cmd => bus_cmd,
		bus_shared => bus_shared,
		bus_modified => bus_modified,
		p_data_req => p_data_req,
		p_data_gnt => p_data_gnt,
		p_data => p_data,
		p_dataID => p_dataID,
		bus_data_busy => bus_data_busy,
		bus_data => bus_data,
		bus_dataID => bus_dataID
	);

PC : program_counter
  port map(
       PCWr => PCWr,
       PC_i => PC_d,
       PC_o => PC_if,
       clk => clk,
       en => PC_en,
       inc2 => PC_inc2
  );

PU : permute_unit
  port map(
       A => D,
       Result => PU_Result,
       op_sel => op_PU
  );

Registers : register_file
  port map(
       A_rd_addr => RA_rf,
       A_rd_data => A_reg,
       A_wr_addr => evenWB_RegDst,
       A_wr_data => evenWB_Result,
       A_wr_en => evenWB_RegWr,
       B_rd_addr => RB_rf,
       B_rd_data => B_reg,
       B_wr_addr => oddWB_RegDst,
       B_wr_data => oddWB_Result,
       B_wr_en => oddWB_RegWr,
       C_rd_addr => RC_rf,
       C_rd_data => C_reg,
       D_rd_addr => RD_rf,
       D_rd_data => D_reg,
       E_rd_addr => RE_rf,
       E_rd_data => E_reg,
       F_rd_addr => RF_rf,
       F_rd_data => F_reg,
       clk => clk
  );

SFU1 : simple_fixed_unit1
  port map(
       A => A,
       B => B,
       Imm => even_Imm,
       Result => SFU1_Result,
       op_sel => op_SFU1
  );

SFU2 : simple_fixed_unit2
  port map(
       A => A,
       B => B,
       Imm => even_Imm,
       Result => SFU2_Result,
       op_sel => op_SFU2
  );

SPU : single_precision_unit
  port map(
       A => A,
       B => B,
       C => C,
       Imm => even_Imm,
       Result => SPU_Result,
       op_sel => op_SPU
  );

end architecture;
