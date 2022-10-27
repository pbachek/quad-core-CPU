-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : spu_lite
-- Author      : pbachek
-- Company     : pbachek
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Paul\Documents\ESE 565\project\spu_lite\spu_lite\compile\spu_lite.vhd
-- Generated   : Sat Oct 24 17:50:38 2020
-- From        : C:\Users\Paul\Documents\ESE 565\project\spu_lite\spu_lite\src\spu_lite.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;

library spu_lite;
use spu_lite_pkg.all;

-- Included from components --
library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity spu_lite is
  port(
       clk : in STD_LOGIC
  );
end spu_lite;

architecture rtl of spu_lite is

---- Component declarations -----

component branch_prediction_unit
  port(
       clk : in STD_LOGIC;
       PC_if : in STD_LOGIC_VECTOR(0 to 31);
       PC_BRU : in STD_LOGIC_VECTOR(0 to 31);
       PCWr_BRU : in STD_LOGIC;
       op_BRU_rf : in STD_LOGIC_VECTOR(0 to 2);
       op_BRU_a : in STD_LOGIC_VECTOR(0 to 2);
       mispredict : out STD_LOGIC;
       PC_br : out STD_LOGIC_VECTOR(0 to 31);
       PC_o : out STD_LOGIC_VECTOR(0 to 31);
       PCWr : out STD_LOGIC
  );
end component;
component branch_reg
  port(
       clk : in STD_LOGIC;
       PC_d : in STD_LOGIC_VECTOR(0 to 31);
       PCWr_d : in STD_LOGIC;
       PC_q : out STD_LOGIC_VECTOR(0 to 31) := (others => '0');
       PCWr_q : out STD_LOGIC := '0'
  );
end component;
component branch_unit
  port(
       op_sel : in STD_LOGIC_VECTOR(0 to 2);
       A : in STD_LOGIC_VECTOR(0 to 127);
       T : in STD_LOGIC_VECTOR(0 to 127);
       Imm : in STD_LOGIC_VECTOR(0 to 15);
       PC : in STD_LOGIC_VECTOR(0 to 31);
       Result : out STD_LOGIC_VECTOR(0 to 31);
       PCWr : out STD_LOGIC
  );
end component;
component byte_unit
  port(
       op_sel : in STD_LOGIC_VECTOR(0 to 1);
       A : in STD_LOGIC_VECTOR(0 to 127);
       B : in STD_LOGIC_VECTOR(0 to 127);
       Result : out STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component decode_reg
  port(
       clk : in STD_LOGIC;
       gate_n : in STD_LOGIC;
       stall_A : in STD_LOGIC;
       stall_B : in STD_LOGIC;
       instruction_A_d : in STD_LOGIC_VECTOR(0 to 31);
       instruction_B_d : in STD_LOGIC_VECTOR(0 to 31);
       instruction_A_q : out STD_LOGIC_VECTOR(0 to 31);
       instruction_B_q : out STD_LOGIC_VECTOR(0 to 31)
  );
end component;
component decode_unit
  port(
       instruction : in STD_LOGIC_VECTOR(0 to 31);
       RegWr : out STD_LOGIC;
       RegDst : out STD_LOGIC_VECTOR(0 to 6);
       Latency : out STD_LOGIC_VECTOR(0 to 2);
       Unit : out STD_LOGIC_VECTOR(0 to 2);
       Imm : out STD_LOGIC_VECTOR(0 to 17);
       op_SFU1 : out STD_LOGIC_VECTOR(0 to 4);
       op_SFU2 : out STD_LOGIC_VECTOR(0 to 2);
       op_SPU : out STD_LOGIC_VECTOR(0 to 3);
       op_BU : out STD_LOGIC_VECTOR(0 to 1);
       op_BRU : out STD_LOGIC_VECTOR(0 to 2);
       op_LSU : out STD_LOGIC_VECTOR(0 to 2);
       op_PU : out STD_LOGIC_VECTOR(0 to 1);
       RA : out STD_LOGIC_VECTOR(0 to 6);
       RA_rd : out STD_LOGIC;
       RB : out STD_LOGIC_VECTOR(0 to 6);
       RB_rd : out STD_LOGIC;
       RC : out STD_LOGIC_VECTOR(0 to 6);
       RC_rd : out STD_LOGIC;
       stop : out STD_LOGIC
  );
end component;
component even_rf_reg
  port(
       clk : in STD_LOGIC;
       gate_n : in STD_LOGIC;
       Unit_d : in STD_LOGIC_VECTOR(0 to 2);
       Latency_d : in STD_LOGIC_VECTOR(0 to 2);
       RegDst_d : in STD_LOGIC_VECTOR(0 to 6);
       RegWr_d : in STD_LOGIC;
       op_SFU1_d : in STD_LOGIC_VECTOR(0 to 4);
       op_SFU2_d : in STD_LOGIC_VECTOR(0 to 2);
       op_SPU_d : in STD_LOGIC_VECTOR(0 to 3);
       op_BU_d : in STD_LOGIC_VECTOR(0 to 1);
       Imm_d : in STD_LOGIC_VECTOR(0 to 17);
       RA_d : in STD_LOGIC_VECTOR(0 to 6);
       RB_d : in STD_LOGIC_VECTOR(0 to 6);
       RC_d : in STD_LOGIC_VECTOR(0 to 6);
       Unit_q : out STD_LOGIC_VECTOR(0 to 2);
       Latency_q : out STD_LOGIC_VECTOR(0 to 2);
       RegDst_q : out STD_LOGIC_VECTOR(0 to 6);
       RegWr_q : out STD_LOGIC;
       op_SFU1_q : out STD_LOGIC_VECTOR(0 to 4);
       op_SFU2_q : out STD_LOGIC_VECTOR(0 to 2);
       op_SPU_q : out STD_LOGIC_VECTOR(0 to 3);
       op_BU_q : out STD_LOGIC_VECTOR(0 to 1);
       Imm_q : out STD_LOGIC_VECTOR(0 to 17);
       RA_q : out STD_LOGIC_VECTOR(0 to 6);
       RB_q : out STD_LOGIC_VECTOR(0 to 6);
       RC_q : out STD_LOGIC_VECTOR(0 to 6)
  );
end component;
component forwarding_unit
  port(
       RA : in STD_LOGIC_VECTOR(0 to 6);
       RB : in STD_LOGIC_VECTOR(0 to 6);
       RC : in STD_LOGIC_VECTOR(0 to 6);
       RD : in STD_LOGIC_VECTOR(0 to 6);
       RE : in STD_LOGIC_VECTOR(0 to 6);
       RF : in STD_LOGIC_VECTOR(0 to 6);
       A_reg : in STD_LOGIC_VECTOR(0 to 127);
       B_reg : in STD_LOGIC_VECTOR(0 to 127);
       C_reg : in STD_LOGIC_VECTOR(0 to 127);
       D_reg : in STD_LOGIC_VECTOR(0 to 127);
       E_reg : in STD_LOGIC_VECTOR(0 to 127);
       F_reg : in STD_LOGIC_VECTOR(0 to 127);
       even2_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even2_RegWr : in STD_LOGIC;
       even2_Result : in STD_LOGIC_VECTOR(0 to 127);
       even3_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even3_RegWr : in STD_LOGIC;
       even3_Result : in STD_LOGIC_VECTOR(0 to 127);
       even4_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even4_RegWr : in STD_LOGIC;
       even4_Result : in STD_LOGIC_VECTOR(0 to 127);
       even5_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even5_RegWr : in STD_LOGIC;
       even5_Result : in STD_LOGIC_VECTOR(0 to 127);
       even6_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even6_RegWr : in STD_LOGIC;
       even6_Result : in STD_LOGIC_VECTOR(0 to 127);
       even7_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even7_RegWr : in STD_LOGIC;
       even7_Result : in STD_LOGIC_VECTOR(0 to 127);
       evenWB_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       evenWB_RegWr : in STD_LOGIC;
       evenWB_Result : in STD_LOGIC_VECTOR(0 to 127);
       odd4_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd4_RegWr : in STD_LOGIC;
       odd4_Result : in STD_LOGIC_VECTOR(0 to 127);
       odd5_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd5_RegWr : in STD_LOGIC;
       odd5_Result : in STD_LOGIC_VECTOR(0 to 127);
       odd6_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd6_RegWr : in STD_LOGIC;
       odd6_Result : in STD_LOGIC_VECTOR(0 to 127);
       odd7_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd7_RegWr : in STD_LOGIC;
       odd7_Result : in STD_LOGIC_VECTOR(0 to 127);
       oddWB_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       oddWB_RegWr : in STD_LOGIC;
       oddWB_Result : in STD_LOGIC_VECTOR(0 to 127);
       A : out STD_LOGIC_VECTOR(0 to 127);
       B : out STD_LOGIC_VECTOR(0 to 127);
       C : out STD_LOGIC_VECTOR(0 to 127);
       D : out STD_LOGIC_VECTOR(0 to 127);
       E : out STD_LOGIC_VECTOR(0 to 127);
       F : out STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component instruction_cache
  port(
       clk : in STD_LOGIC;
       PC : in STD_LOGIC_VECTOR(0 to 31);
       A_instruction : out STD_LOGIC_VECTOR(0 to 31);
       A_hit : out STD_LOGIC;
       B_instruction : out STD_LOGIC_VECTOR(0 to 31);
       B_hit : out STD_LOGIC;
       mem_addr : out STD_LOGIC_VECTOR(0 to 31) := (others => '0');
       mem_data : in STD_LOGIC_VECTOR(0 to 7)
  );
end component;
component instruction_memory
  port(
       addr : in STD_LOGIC_VECTOR(0 to 31);
       data : out STD_LOGIC_VECTOR(0 to 7)
  );
end component;
component issue_control_unit
  port(
       a_RegWr : in STD_LOGIC;
       a_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       a_Latency : in STD_LOGIC_VECTOR(0 to 2);
       a_Unit : in STD_LOGIC_VECTOR(0 to 2);
       a_Imm : in STD_LOGIC_VECTOR(0 to 17);
       a_op_SFU1 : in STD_LOGIC_VECTOR(0 to 4);
       a_op_SFU2 : in STD_LOGIC_VECTOR(0 to 2);
       a_op_SPU : in STD_LOGIC_VECTOR(0 to 3);
       a_op_BU : in STD_LOGIC_VECTOR(0 to 1);
       a_op_BRU : in STD_LOGIC_VECTOR(0 to 2);
       a_op_LSU : in STD_LOGIC_VECTOR(0 to 2);
       a_op_PU : in STD_LOGIC_VECTOR(0 to 1);
       a_RA : in STD_LOGIC_VECTOR(0 to 6);
       a_RA_rd : in STD_LOGIC;
       a_RB : in STD_LOGIC_VECTOR(0 to 6);
       a_RB_rd : in STD_LOGIC;
       a_RC : in STD_LOGIC_VECTOR(0 to 6);
       a_RC_rd : in STD_LOGIC;
       a_stop : in STD_LOGIC;
       b_RegWr : in STD_LOGIC;
       b_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       b_Latency : in STD_LOGIC_VECTOR(0 to 2);
       b_Unit : in STD_LOGIC_VECTOR(0 to 2);
       b_Imm : in STD_LOGIC_VECTOR(0 to 17);
       b_op_SFU1 : in STD_LOGIC_VECTOR(0 to 4);
       b_op_SFU2 : in STD_LOGIC_VECTOR(0 to 2);
       b_op_SPU : in STD_LOGIC_VECTOR(0 to 3);
       b_op_BU : in STD_LOGIC_VECTOR(0 to 1);
       b_op_BRU : in STD_LOGIC_VECTOR(0 to 2);
       b_op_LSU : in STD_LOGIC_VECTOR(0 to 2);
       b_op_PU : in STD_LOGIC_VECTOR(0 to 1);
       b_RA : in STD_LOGIC_VECTOR(0 to 6);
       b_RA_rd : in STD_LOGIC;
       b_RB : in STD_LOGIC_VECTOR(0 to 6);
       b_RB_rd : in STD_LOGIC;
       b_RC : in STD_LOGIC_VECTOR(0 to 6);
       b_RC_rd : in STD_LOGIC;
       b_stop : in STD_LOGIC;
       even5_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even5_RegWr : in STD_LOGIC;
       even5_Latency : in STD_LOGIC_VECTOR(0 to 2);
       even0_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even0_RegWr : in STD_LOGIC;
       even0_Latency : in STD_LOGIC_VECTOR(0 to 2);
       even1_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even1_RegWr : in STD_LOGIC;
       even1_Latency : in STD_LOGIC_VECTOR(0 to 2);
       even2_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even2_RegWr : in STD_LOGIC;
       even2_Latency : in STD_LOGIC_VECTOR(0 to 2);
       even3_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even3_RegWr : in STD_LOGIC;
       even3_Latency : in STD_LOGIC_VECTOR(0 to 2);
       even4_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       even4_RegWr : in STD_LOGIC;
       even4_Latency : in STD_LOGIC_VECTOR(0 to 2);
       odd4_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd4_RegWr : in STD_LOGIC;
       odd4_Latency : in STD_LOGIC_VECTOR(0 to 2);
       odd0_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd0_RegWr : in STD_LOGIC;
       odd0_Latency : in STD_LOGIC_VECTOR(0 to 2);
       odd1_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd1_RegWr : in STD_LOGIC;
       odd1_Latency : in STD_LOGIC_VECTOR(0 to 2);
       odd2_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd2_RegWr : in STD_LOGIC;
       odd2_Latency : in STD_LOGIC_VECTOR(0 to 2);
       odd3_RegDst : in STD_LOGIC_VECTOR(0 to 6);
       odd3_RegWr : in STD_LOGIC;
       odd3_Latency : in STD_LOGIC_VECTOR(0 to 2);
       even_RegWr : out STD_LOGIC;
       even_RegDst : out STD_LOGIC_VECTOR(0 to 6);
       even_Latency : out STD_LOGIC_VECTOR(0 to 2);
       even_Unit : out STD_LOGIC_VECTOR(0 to 2);
       even_Imm : out STD_LOGIC_VECTOR(0 to 17);
       op_SFU1 : out STD_LOGIC_VECTOR(0 to 4);
       op_SFU2 : out STD_LOGIC_VECTOR(0 to 2);
       op_SPU : out STD_LOGIC_VECTOR(0 to 3);
       op_BU : out STD_LOGIC_VECTOR(0 to 1);
       RA : out STD_LOGIC_VECTOR(0 to 6);
       RB : out STD_LOGIC_VECTOR(0 to 6);
       RC : out STD_LOGIC_VECTOR(0 to 6);
       odd_RegWr : out STD_LOGIC;
       odd_RegDst : out STD_LOGIC_VECTOR(0 to 6);
       odd_Latency : out STD_LOGIC_VECTOR(0 to 2);
       odd_Unit : out STD_LOGIC_VECTOR(0 to 2);
       odd_Imm : out STD_LOGIC_VECTOR(0 to 15);
       op_BRU : out STD_LOGIC_VECTOR(0 to 2);
       op_LSU : out STD_LOGIC_VECTOR(0 to 2);
       op_PU : out STD_LOGIC_VECTOR(0 to 1);
       RD : out STD_LOGIC_VECTOR(0 to 6);
       RE : out STD_LOGIC_VECTOR(0 to 6);
       RF : out STD_LOGIC_VECTOR(0 to 6);
       a_fetch : out STD_LOGIC;
       b_fetch : out STD_LOGIC
  );
end component;
component local_store_unit
  port(
       clk : in STD_LOGIC;
       op_sel : in STD_LOGIC_VECTOR(0 to 2);
       A : in STD_LOGIC_VECTOR(0 to 127);
       B : in STD_LOGIC_VECTOR(0 to 127);
       T : in STD_LOGIC_VECTOR(0 to 127);
       Imm : in STD_LOGIC_VECTOR(0 to 15);
       Result : out STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component odd_rf_reg
  port(
       clk : in STD_LOGIC;
       gate_n : in STD_LOGIC;
       Unit_d : in STD_LOGIC_VECTOR(0 to 2);
       Latency_d : in STD_LOGIC_VECTOR(0 to 2);
       RegDst_d : in STD_LOGIC_VECTOR(0 to 6);
       RegWr_d : in STD_LOGIC;
       op_LSU_d : in STD_LOGIC_VECTOR(0 to 2);
       op_PU_d : in STD_LOGIC_VECTOR(0 to 1);
       op_BRU_d : in STD_LOGIC_VECTOR(0 to 2);
       PC_d : in STD_LOGIC_VECTOR(0 to 31);
       Imm_d : in STD_LOGIC_VECTOR(0 to 15);
       RD_d : in STD_LOGIC_VECTOR(0 to 6);
       RE_d : in STD_LOGIC_VECTOR(0 to 6);
       RF_d : in STD_LOGIC_VECTOR(0 to 6);
       Unit_q : out STD_LOGIC_VECTOR(0 to 2);
       Latency_q : out STD_LOGIC_VECTOR(0 to 2);
       RegDst_q : out STD_LOGIC_VECTOR(0 to 6);
       RegWr_q : out STD_LOGIC;
       op_LSU_q : out STD_LOGIC_VECTOR(0 to 2);
       op_PU_q : out STD_LOGIC_VECTOR(0 to 1);
       op_BRU_q : out STD_LOGIC_VECTOR(0 to 2);
       PC_q : out STD_LOGIC_VECTOR(0 to 31);
       Imm_q : out STD_LOGIC_VECTOR(0 to 15);
       RD_q : out STD_LOGIC_VECTOR(0 to 6);
       RE_q : out STD_LOGIC_VECTOR(0 to 6);
       RF_q : out STD_LOGIC_VECTOR(0 to 6)
  );
end component;
component permute_unit
  port(
       op_sel : in STD_LOGIC_VECTOR(0 to 1);
       A : in STD_LOGIC_VECTOR(0 to 127);
       Result : out STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component pipe_reg
  port(
       clk : in STD_LOGIC;
       Result_d : in STD_LOGIC_VECTOR(0 to 127);
       Unit_d : in STD_LOGIC_VECTOR(0 to 2);
       Latency_d : in STD_LOGIC_VECTOR(0 to 2);
       RegDst_d : in STD_LOGIC_VECTOR(0 to 6);
       RegWr_d : in STD_LOGIC;
       Result_q : out STD_LOGIC_VECTOR(0 to 127) := (others => '0');
       Unit_q : out STD_LOGIC_VECTOR(0 to 2) := (others => '0');
       Latency_q : out STD_LOGIC_VECTOR(0 to 2) := (others => '0');
       RegDst_q : out STD_LOGIC_VECTOR(0 to 6) := (others => '0');
       RegWr_q : out STD_LOGIC := '0'
  );
end component;
component program_counter
  port(
       clk : in STD_LOGIC;
       PC_i : in STD_LOGIC_VECTOR(0 to 31);
       PCWr : in STD_LOGIC;
       PC_o : out STD_LOGIC_VECTOR(0 to 31);
       en : in STD_LOGIC;
       inc2 : in STD_LOGIC
  );
end component;
component register_file
  port(
       clk : in STD_LOGIC;
       A_rd_addr : in STD_LOGIC_VECTOR(0 to 6);
       A_rd_data : out STD_LOGIC_VECTOR(0 to 127) := (others => '0');
       B_rd_addr : in STD_LOGIC_VECTOR(0 to 6);
       B_rd_data : out STD_LOGIC_VECTOR(0 to 127) := (others => '0');
       C_rd_addr : in STD_LOGIC_VECTOR(0 to 6);
       C_rd_data : out STD_LOGIC_VECTOR(0 to 127) := (others => '0');
       D_rd_addr : in STD_LOGIC_VECTOR(0 to 6);
       D_rd_data : out STD_LOGIC_VECTOR(0 to 127) := (others => '0');
       E_rd_addr : in STD_LOGIC_VECTOR(0 to 6);
       E_rd_data : out STD_LOGIC_VECTOR(0 to 127) := (others => '0');
       F_rd_addr : in STD_LOGIC_VECTOR(0 to 6);
       F_rd_data : out STD_LOGIC_VECTOR(0 to 127) := (others => '0');
       A_wr_en : in STD_LOGIC;
       A_wr_addr : in STD_LOGIC_VECTOR(0 to 6);
       A_wr_data : in STD_LOGIC_VECTOR(0 to 127);
       B_wr_en : in STD_LOGIC;
       B_wr_addr : in STD_LOGIC_VECTOR(0 to 6);
       B_wr_data : in STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component result_mux
  generic(
       G_UNIT : unit_t;
       G_LATENCY : NATURAL
  );
  port(
       Unit_sel : in STD_LOGIC_VECTOR(0 to 2);
       Latency : in STD_LOGIC_VECTOR(0 to 2);
       Result0 : in STD_LOGIC_VECTOR(0 to 127);
       Result1 : in STD_LOGIC_VECTOR(0 to 127);
       Result : out STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component result_reg
  port(
       clk : in STD_LOGIC;
       d : in STD_LOGIC_VECTOR(0 to 127);
       q : out STD_LOGIC_VECTOR(0 to 127) := (others => '0')
  );
end component;
component simple_fixed_unit1
  port(
       op_sel : in STD_LOGIC_VECTOR(0 to 4);
       A : in STD_LOGIC_VECTOR(0 to 127);
       B : in STD_LOGIC_VECTOR(0 to 127);
       Imm : in STD_LOGIC_VECTOR(0 to 17);
       Result : out STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component simple_fixed_unit2
  port(
       op_sel : in STD_LOGIC_VECTOR(0 to 2);
       A : in STD_LOGIC_VECTOR(0 to 127);
       B : in STD_LOGIC_VECTOR(0 to 127);
       Imm : in STD_LOGIC_VECTOR(0 to 17);
       Result : out STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component single_precision_unit
  port(
       op_sel : in STD_LOGIC_VECTOR(0 to 3);
       A : in STD_LOGIC_VECTOR(0 to 127);
       B : in STD_LOGIC_VECTOR(0 to 127);
       C : in STD_LOGIC_VECTOR(0 to 127);
       Imm : in STD_LOGIC_VECTOR(0 to 17);
       Result : out STD_LOGIC_VECTOR(0 to 127)
  );
end component;
component dff
  port(
       clk : in STD_LOGIC;
       d : in STD_LOGIC;
       q : out STD_LOGIC := '0'
  );
end component;

----     Constants     -----
constant GND_CONSTANT   : STD_LOGIC := '0';

---- Signal declarations used on the diagram ----

signal A_cache_hit : STD_LOGIC;
signal A_cache_hit_n : STD_LOGIC;
signal A_cache_hit_q : STD_LOGIC;
signal a_fetch : STD_LOGIC;
signal a_RA_rd : STD_LOGIC;
signal a_RB_rd : STD_LOGIC;
signal a_RC_rd : STD_LOGIC;
signal a_RegWr : STD_LOGIC;
signal a_stop : STD_LOGIC;
signal branch_mispredict : STD_LOGIC;
signal B_cache_hit : STD_LOGIC;
signal B_cache_hit_q : STD_LOGIC;
signal b_fetch : STD_LOGIC;
signal b_RA_rd : STD_LOGIC;
signal b_RB_rd : STD_LOGIC;
signal b_RC_rd : STD_LOGIC;
signal b_RegWr : STD_LOGIC;
signal b_stop : STD_LOGIC;
signal even0_RegWr : STD_LOGIC;
signal even1_RegWr : STD_LOGIC;
signal even2_RegWr : STD_LOGIC;
signal even3_RegWr : STD_LOGIC;
signal even4_RegWr : STD_LOGIC;
signal even5_RegWr : STD_LOGIC;
signal even6_RegWr : STD_LOGIC;
signal even7_RegWr : STD_LOGIC;
signal evenWB_RegWr : STD_LOGIC;
signal even_RegWr_rf : STD_LOGIC;
signal GND : STD_LOGIC;
signal odd0_RegWr : STD_LOGIC;
signal odd1_RegWr : STD_LOGIC;
signal odd2_RegWr : STD_LOGIC;
signal odd3_RegWr : STD_LOGIC;
signal odd4_RegWr : STD_LOGIC;
signal odd5_RegWr : STD_LOGIC;
signal odd6_RegWr : STD_LOGIC;
signal odd7_RegWr : STD_LOGIC;
signal oddWB_RegWr : STD_LOGIC;
signal odd_RegWr_rf : STD_LOGIC;
signal PCWr : STD_LOGIC;
signal PCWr1 : STD_LOGIC;
signal PCWr_BRU : STD_LOGIC;
signal PC_en : STD_LOGIC;
signal PC_inc2 : STD_LOGIC;
signal stall_B : STD_LOGIC;
signal A : STD_LOGIC_VECTOR(0 to 127);
signal a_Imm : STD_LOGIC_VECTOR(0 to 17);
signal a_Latency : STD_LOGIC_VECTOR(0 to 2);
signal a_op_BRU : STD_LOGIC_VECTOR(0 to 2);
signal a_op_BU : STD_LOGIC_VECTOR(0 to 1);
signal a_op_LSU : STD_LOGIC_VECTOR(0 to 2);
signal a_op_PU : STD_LOGIC_VECTOR(0 to 1);
signal a_op_SFU1 : STD_LOGIC_VECTOR(0 to 4);
signal a_op_SFU2 : STD_LOGIC_VECTOR(0 to 2);
signal a_op_SPU : STD_LOGIC_VECTOR(0 to 3);
signal a_RA : STD_LOGIC_VECTOR(0 to 6);
signal a_RB : STD_LOGIC_VECTOR(0 to 6);
signal a_RC : STD_LOGIC_VECTOR(0 to 6);
signal A_reg : STD_LOGIC_VECTOR(0 to 127);
signal a_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal a_Unit : STD_LOGIC_VECTOR(0 to 2);
signal B : STD_LOGIC_VECTOR(0 to 127);
signal BU_Result : STD_LOGIC_VECTOR(0 to 127);
signal BU_Result1 : STD_LOGIC_VECTOR(0 to 127);
signal BU_Result2 : STD_LOGIC_VECTOR(0 to 127);
signal BU_Result3 : STD_LOGIC_VECTOR(0 to 127);
signal b_Imm : STD_LOGIC_VECTOR(0 to 17);
signal b_Latency : STD_LOGIC_VECTOR(0 to 2);
signal b_op_BRU : STD_LOGIC_VECTOR(0 to 2);
signal b_op_BU : STD_LOGIC_VECTOR(0 to 1);
signal b_op_LSU : STD_LOGIC_VECTOR(0 to 2);
signal b_op_PU : STD_LOGIC_VECTOR(0 to 1);
signal b_op_SFU1 : STD_LOGIC_VECTOR(0 to 4);
signal b_op_SFU2 : STD_LOGIC_VECTOR(0 to 2);
signal b_op_SPU : STD_LOGIC_VECTOR(0 to 3);
signal b_RA : STD_LOGIC_VECTOR(0 to 6);
signal b_RB : STD_LOGIC_VECTOR(0 to 6);
signal b_RC : STD_LOGIC_VECTOR(0 to 6);
signal B_reg : STD_LOGIC_VECTOR(0 to 127);
signal b_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal b_Unit : STD_LOGIC_VECTOR(0 to 2);
signal C : STD_LOGIC_VECTOR(0 to 127);
signal C_reg : STD_LOGIC_VECTOR(0 to 127);
signal D : STD_LOGIC_VECTOR(0 to 127);
signal D_reg : STD_LOGIC_VECTOR(0 to 127);
signal E : STD_LOGIC_VECTOR(0 to 127);
signal even0_Latency : STD_LOGIC_VECTOR(0 to 2);
signal even0_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal even0_Unit : STD_LOGIC_VECTOR(0 to 2);
signal even1_Latency : STD_LOGIC_VECTOR(0 to 2);
signal even1_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal even1_Result : STD_LOGIC_VECTOR(0 to 127);
signal even1_Unit : STD_LOGIC_VECTOR(0 to 2);
signal even2_Latency : STD_LOGIC_VECTOR(0 to 2);
signal even2_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal even2_Result : STD_LOGIC_VECTOR(0 to 127);
signal even2_Result_MUX : STD_LOGIC_VECTOR(0 to 127);
signal even2_Unit : STD_LOGIC_VECTOR(0 to 2);
signal even3_Latency : STD_LOGIC_VECTOR(0 to 2);
signal even3_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal even3_Result : STD_LOGIC_VECTOR(0 to 127);
signal even3_Result_MUX1 : STD_LOGIC_VECTOR(0 to 127);
signal even3_Result_MUX2 : STD_LOGIC_VECTOR(0 to 127);
signal even3_Unit : STD_LOGIC_VECTOR(0 to 2);
signal even4_Latency : STD_LOGIC_VECTOR(0 to 2);
signal even4_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal even4_Result : STD_LOGIC_VECTOR(0 to 127);
signal even4_Unit : STD_LOGIC_VECTOR(0 to 2);
signal even5_Latency : STD_LOGIC_VECTOR(0 to 2);
signal even5_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal even5_Result : STD_LOGIC_VECTOR(0 to 127);
signal even5_Unit : STD_LOGIC_VECTOR(0 to 2);
signal even6_Latency : STD_LOGIC_VECTOR(0 to 2);
signal even6_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal even6_Result : STD_LOGIC_VECTOR(0 to 127);
signal even6_Result_MUX : STD_LOGIC_VECTOR(0 to 127);
signal even6_Unit : STD_LOGIC_VECTOR(0 to 2);
signal even7_Latency : STD_LOGIC_VECTOR(0 to 2);
signal even7_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal even7_Result : STD_LOGIC_VECTOR(0 to 127);
signal even7_Result_MUX : STD_LOGIC_VECTOR(0 to 127);
signal even7_Unit : STD_LOGIC_VECTOR(0 to 2);
signal evenWB_Latency : STD_LOGIC_VECTOR(0 to 2);
signal evenWB_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal evenWB_Result : STD_LOGIC_VECTOR(0 to 127);
signal evenWB_Unit : STD_LOGIC_VECTOR(0 to 2);
signal even_Imm : STD_LOGIC_VECTOR(0 to 17);
signal even_Imm_rf : STD_LOGIC_VECTOR(0 to 17);
signal even_Latency_rf : STD_LOGIC_VECTOR(0 to 2);
signal even_RegDst_rf : STD_LOGIC_VECTOR(0 to 6);
signal even_Unit_rf : STD_LOGIC_VECTOR(0 to 2);
signal E_reg : STD_LOGIC_VECTOR(0 to 127);
signal F : STD_LOGIC_VECTOR(0 to 127);
signal F_reg : STD_LOGIC_VECTOR(0 to 127);
signal GND_128 : STD_LOGIC_VECTOR(0 to 127);
signal instruction_A_dec : STD_LOGIC_VECTOR(0 to 31);
signal instruction_A_if : STD_LOGIC_VECTOR(0 to 31);
signal instruction_B_dec : STD_LOGIC_VECTOR(0 to 31);
signal instruction_B_if : STD_LOGIC_VECTOR(0 to 31);
signal instruction_mem_addr : STD_LOGIC_VECTOR(0 to 31);
signal instruction_mem_data : STD_LOGIC_VECTOR(0 to 7);
signal LSU_Result : STD_LOGIC_VECTOR(0 to 127);
signal LSU_Result1 : STD_LOGIC_VECTOR(0 to 127);
signal LSU_Result2 : STD_LOGIC_VECTOR(0 to 127);
signal LSU_Result3 : STD_LOGIC_VECTOR(0 to 127);
signal LSU_Result4 : STD_LOGIC_VECTOR(0 to 127);
signal LSU_Result5 : STD_LOGIC_VECTOR(0 to 127);
signal LSU_Result6 : STD_LOGIC_VECTOR(0 to 127);
signal odd0_Latency : STD_LOGIC_VECTOR(0 to 2);
signal odd0_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal odd0_Unit : STD_LOGIC_VECTOR(0 to 2);
signal odd1_Latency : STD_LOGIC_VECTOR(0 to 2);
signal odd1_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal odd1_Result : STD_LOGIC_VECTOR(0 to 127);
signal odd1_Unit : STD_LOGIC_VECTOR(0 to 2);
signal odd2_Latency : STD_LOGIC_VECTOR(0 to 2);
signal odd2_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal odd2_Result : STD_LOGIC_VECTOR(0 to 127);
signal odd2_Unit : STD_LOGIC_VECTOR(0 to 2);
signal odd3_Latency : STD_LOGIC_VECTOR(0 to 2);
signal odd3_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal odd3_Result : STD_LOGIC_VECTOR(0 to 127);
signal odd3_Result_MUX : STD_LOGIC_VECTOR(0 to 127);
signal odd3_Unit : STD_LOGIC_VECTOR(0 to 2);
signal odd4_Latency : STD_LOGIC_VECTOR(0 to 2);
signal odd4_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal odd4_Result : STD_LOGIC_VECTOR(0 to 127);
signal odd4_Unit : STD_LOGIC_VECTOR(0 to 2);
signal odd5_Latency : STD_LOGIC_VECTOR(0 to 2);
signal odd5_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal odd5_Result : STD_LOGIC_VECTOR(0 to 127);
signal odd5_Unit : STD_LOGIC_VECTOR(0 to 2);
signal odd6_Latency : STD_LOGIC_VECTOR(0 to 2);
signal odd6_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal odd6_Result : STD_LOGIC_VECTOR(0 to 127);
signal odd6_Result_MUX : STD_LOGIC_VECTOR(0 to 127);
signal odd6_Unit : STD_LOGIC_VECTOR(0 to 2);
signal odd7_Latency : STD_LOGIC_VECTOR(0 to 2);
signal odd7_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal odd7_Result : STD_LOGIC_VECTOR(0 to 127);
signal odd7_Unit : STD_LOGIC_VECTOR(0 to 2);
signal oddWB_Latency : STD_LOGIC_VECTOR(0 to 2);
signal oddWB_RegDst : STD_LOGIC_VECTOR(0 to 6);
signal oddWB_Result : STD_LOGIC_VECTOR(0 to 127);
signal oddWB_Unit : STD_LOGIC_VECTOR(0 to 2);
signal odd_Imm : STD_LOGIC_VECTOR(0 to 15);
signal odd_Imm_rf : STD_LOGIC_VECTOR(0 to 15);
signal odd_Latency_rf : STD_LOGIC_VECTOR(0 to 2);
signal odd_RegDst_rf : STD_LOGIC_VECTOR(0 to 6);
signal odd_Unit_rf : STD_LOGIC_VECTOR(0 to 2);
signal op_BRU : STD_LOGIC_VECTOR(0 to 2);
signal op_BRU_rf : STD_LOGIC_VECTOR(0 to 2);
signal op_BU : STD_LOGIC_VECTOR(0 to 1);
signal op_BU_rf : STD_LOGIC_VECTOR(0 to 1);
signal op_LSU : STD_LOGIC_VECTOR(0 to 2);
signal op_LSU_rf : STD_LOGIC_VECTOR(0 to 2);
signal op_PU : STD_LOGIC_VECTOR(0 to 1);
signal op_PU_rf : STD_LOGIC_VECTOR(0 to 1);
signal op_SFU1 : STD_LOGIC_VECTOR(0 to 4);
signal op_SFU1_rf : STD_LOGIC_VECTOR(0 to 4);
signal op_SFU2 : STD_LOGIC_VECTOR(0 to 2);
signal op_SFU2_rf : STD_LOGIC_VECTOR(0 to 2);
signal op_SPU : STD_LOGIC_VECTOR(0 to 3);
signal op_SPU_rf : STD_LOGIC_VECTOR(0 to 3);
signal PC_BRU : STD_LOGIC_VECTOR(0 to 31);
signal PC_BRU1 : STD_LOGIC_VECTOR(0 to 31);
signal PC_d : STD_LOGIC_VECTOR(0 to 31);
signal PC_fw : STD_LOGIC_VECTOR(0 to 31);
signal PC_if : STD_LOGIC_VECTOR(0 to 31);
signal PC_rf : STD_LOGIC_VECTOR(0 to 31);
signal PU_Result : STD_LOGIC_VECTOR(0 to 127);
signal PU_Result1 : STD_LOGIC_VECTOR(0 to 127);
signal PU_Result2 : STD_LOGIC_VECTOR(0 to 127);
signal PU_Result3 : STD_LOGIC_VECTOR(0 to 127);
signal RA_fw : STD_LOGIC_VECTOR(0 to 6);
signal RA_rf : STD_LOGIC_VECTOR(0 to 6);
signal RB_fw : STD_LOGIC_VECTOR(0 to 6);
signal RB_rf : STD_LOGIC_VECTOR(0 to 6);
signal RC_fw : STD_LOGIC_VECTOR(0 to 6);
signal RC_rf : STD_LOGIC_VECTOR(0 to 6);
signal RD_fw : STD_LOGIC_VECTOR(0 to 6);
signal RD_rf : STD_LOGIC_VECTOR(0 to 6);
signal RE_fw : STD_LOGIC_VECTOR(0 to 6);
signal RE_rf : STD_LOGIC_VECTOR(0 to 6);
signal RF_fw : STD_LOGIC_VECTOR(0 to 6);
signal RF_rf : STD_LOGIC_VECTOR(0 to 6);
signal SFU1_Result : STD_LOGIC_VECTOR(0 to 127);
signal SFU1_Result1 : STD_LOGIC_VECTOR(0 to 127);
signal SFU1_Result2 : STD_LOGIC_VECTOR(0 to 127);
signal SFU2_Result : STD_LOGIC_VECTOR(0 to 127);
signal SFU2_Result1 : STD_LOGIC_VECTOR(0 to 127);
signal SFU2_Result2 : STD_LOGIC_VECTOR(0 to 127);
signal SFU_Result3 : STD_LOGIC_VECTOR(0 to 127);
signal SPU_Result : STD_LOGIC_VECTOR(0 to 127);
signal SPU_Result1 : STD_LOGIC_VECTOR(0 to 127);
signal SPU_Result2 : STD_LOGIC_VECTOR(0 to 127);
signal SPU_Result3 : STD_LOGIC_VECTOR(0 to 127);
signal SPU_Result4 : STD_LOGIC_VECTOR(0 to 127);
signal SPU_Result5 : STD_LOGIC_VECTOR(0 to 127);
signal SPU_Result6 : STD_LOGIC_VECTOR(0 to 127);
signal SPU_Result7 : STD_LOGIC_VECTOR(0 to 127);

begin

----  Component instantiations  ----

A_miss_ff : dff
  port map(
       clk => clk,
       d => A_cache_hit,
       q => A_cache_hit_q
  );

BRU : branch_unit
  port map(
       op_sel => op_BRU,
       A => D,
       T => F,
       Imm => odd_Imm,
       PC => PC_fw,
       Result => PC_BRU,
       PCWr => PCWr_BRU
  );

BRU_pipe1 : branch_reg
  port map(
       clk => clk,
       PC_d => PC_BRU,
       PCWr_d => PCWr_BRU,
       PC_q => PC_BRU1,
       PCWr_q => PCWr1
  );

BU : byte_unit
  port map(
       op_sel => op_BU,
       A => A,
       B => B,
       Result => BU_Result
  );

BU_MUX : result_mux
  generic map(
       G_UNIT => UNIT_BYTE,
       G_LATENCY => 4
  )
  port map(
       Unit_sel => even3_Unit,
       Latency => even3_Latency,
       Result0 => even3_Result_MUX1,
       Result1 => BU_Result3,
       Result => even3_Result_MUX2
  );

BU_pipe1 : result_reg
  port map(
       clk => clk,
       d => BU_Result,
       q => BU_Result1
  );

BU_pipe2 : result_reg
  port map(
       clk => clk,
       d => BU_Result1,
       q => BU_Result2
  );

BU_pipe3 : result_reg
  port map(
       clk => clk,
       d => BU_Result2,
       q => BU_Result3
  );

B_miss_ff : dff
  port map(
       clk => clk,
       d => B_cache_hit,
       q => B_cache_hit_q
  );

Branch_prediction : branch_prediction_unit
  port map(
       clk => clk,
       PC_if => PC_if,
       PC_BRU => PC_BRU1,
       PCWr_BRU => PCWr1,
       op_BRU_rf => op_BRU_rf,
       op_BRU_a => a_op_BRU,
       mispredict => branch_mispredict,
       PC_br => PC_rf,
       PC_o => PC_d,
       PCWr => PCWr
  );

Decode : decode_reg
  port map(
       clk => clk,
       gate_n => branch_mispredict,
       stall_A => A_cache_hit_n,
       stall_B => stall_B,
       instruction_A_d => instruction_A_if,
       instruction_B_d => instruction_B_if,
       instruction_A_q => instruction_A_dec,
       instruction_B_q => instruction_B_dec
  );

Decode_A : decode_unit
  port map(
       instruction => instruction_A_dec,
       RegWr => a_RegWr,
       RegDst => a_RegDst,
       Latency => a_Latency,
       Unit => a_Unit,
       Imm => a_Imm,
       op_SFU1 => a_op_SFU1,
       op_SFU2 => a_op_SFU2,
       op_SPU => a_op_SPU,
       op_BU => a_op_BU,
       op_BRU => a_op_BRU,
       op_LSU => a_op_LSU,
       op_PU => a_op_PU,
       RA => a_RA,
       RA_rd => a_RA_rd,
       RB => a_RB,
       RB_rd => a_RB_rd,
       RC => a_RC,
       RC_rd => a_RC_rd,
       stop => a_stop
  );

Decode_B : decode_unit
  port map(
       instruction => instruction_B_dec,
       RegWr => b_RegWr,
       RegDst => b_RegDst,
       Latency => b_Latency,
       Unit => b_Unit,
       Imm => b_Imm,
       op_SFU1 => b_op_SFU1,
       op_SFU2 => b_op_SFU2,
       op_SPU => b_op_SPU,
       op_BU => b_op_BU,
       op_BRU => b_op_BRU,
       op_LSU => b_op_LSU,
       op_PU => b_op_PU,
       RA => b_RA,
       RA_rd => b_RA_rd,
       RB => b_RB,
       RB_rd => b_RB_rd,
       RC => b_RC,
       RC_rd => b_RC_rd,
       stop => b_stop
  );

Even_RF : even_rf_reg
  port map(
       clk => clk,
       gate_n => branch_mispredict,
       Unit_d => even_Unit_rf,
       Latency_d => even_Latency_rf,
       RegDst_d => even_RegDst_rf,
       RegWr_d => even_RegWr_rf,
       op_SFU1_d => op_SFU1_rf,
       op_SFU2_d => op_SFU2_rf,
       op_SPU_d => op_SPU_rf,
       op_BU_d => op_BU_rf,
       Imm_d => even_Imm_rf,
       RA_d => RA_rf,
       RB_d => RB_rf,
       RC_d => RC_rf,
       Unit_q => even0_Unit,
       Latency_q => even0_Latency,
       RegDst_q => even0_RegDst,
       RegWr_q => even0_RegWr,
       op_SFU1_q => op_SFU1,
       op_SFU2_q => op_SFU2,
       op_SPU_q => op_SPU,
       op_BU_q => op_BU,
       Imm_q => even_Imm,
       RA_q => RA_fw,
       RB_q => RB_fw,
       RC_q => RC_fw
  );

Even_WB : pipe_reg
  port map(
       clk => clk,
       Result_d => even7_Result_MUX,
       Unit_d => even7_Unit,
       Latency_d => even7_Latency,
       RegDst_d => even7_RegDst,
       RegWr_d => even7_RegWr,
       Result_q => evenWB_Result,
       Unit_q => evenWB_Unit,
       Latency_q => evenWB_Latency,
       RegDst_q => evenWB_RegDst,
       RegWr_q => evenWB_RegWr
  );

Even_pipe1 : pipe_reg
  port map(
       clk => clk,
       Result_d => GND_128,
       Unit_d => even0_Unit,
       Latency_d => even0_Latency,
       RegDst_d => even0_RegDst,
       RegWr_d => even0_RegWr,
       Result_q => even1_Result,
       Unit_q => even1_Unit,
       Latency_q => even1_Latency,
       RegDst_q => even1_RegDst,
       RegWr_q => even1_RegWr
  );

Even_pipe2 : pipe_reg
  port map(
       clk => clk,
       Result_d => even1_Result,
       Unit_d => even1_Unit,
       Latency_d => even1_Latency,
       RegDst_d => even1_RegDst,
       RegWr_d => even1_RegWr,
       Result_q => even2_Result,
       Unit_q => even2_Unit,
       Latency_q => even2_Latency,
       RegDst_q => even2_RegDst,
       RegWr_q => even2_RegWr
  );

Even_pipe3 : pipe_reg
  port map(
       clk => clk,
       Result_d => even2_Result_MUX,
       Unit_d => even2_Unit,
       Latency_d => even2_Latency,
       RegDst_d => even2_RegDst,
       RegWr_d => even2_RegWr,
       Result_q => even3_Result,
       Unit_q => even3_Unit,
       Latency_q => even3_Latency,
       RegDst_q => even3_RegDst,
       RegWr_q => even3_RegWr
  );

Even_pipe4 : pipe_reg
  port map(
       clk => clk,
       Result_d => even3_Result_MUX2,
       Unit_d => even3_Unit,
       Latency_d => even3_Latency,
       RegDst_d => even3_RegDst,
       RegWr_d => even3_RegWr,
       Result_q => even4_Result,
       Unit_q => even4_Unit,
       Latency_q => even4_Latency,
       RegDst_q => even4_RegDst,
       RegWr_q => even4_RegWr
  );

Even_pipe5 : pipe_reg
  port map(
       clk => clk,
       Result_d => even4_Result,
       Unit_d => even4_Unit,
       Latency_d => even4_Latency,
       RegDst_d => even4_RegDst,
       RegWr_d => even4_RegWr,
       Result_q => even5_Result,
       Unit_q => even5_Unit,
       Latency_q => even5_Latency,
       RegDst_q => even5_RegDst,
       RegWr_q => even5_RegWr
  );

Even_pipe6 : pipe_reg
  port map(
       clk => clk,
       Result_d => even5_Result,
       Unit_d => even5_Unit,
       Latency_d => even5_Latency,
       RegDst_d => even5_RegDst,
       RegWr_d => even5_RegWr,
       Result_q => even6_Result,
       Unit_q => even6_Unit,
       Latency_q => even6_Latency,
       RegDst_q => even6_RegDst,
       RegWr_q => even6_RegWr
  );

Even_pipe7 : pipe_reg
  port map(
       clk => clk,
       Result_d => even6_Result_MUX,
       Unit_d => even6_Unit,
       Latency_d => even6_Latency,
       RegDst_d => even6_RegDst,
       RegWr_d => even6_RegWr,
       Result_q => even7_Result,
       Unit_q => even7_Unit,
       Latency_q => even7_Latency,
       RegDst_q => even7_RegDst,
       RegWr_q => even7_RegWr
  );

FWD_Unit : forwarding_unit
  port map(
       RA => RA_fw,
       RB => RB_fw,
       RC => RC_fw,
       RD => RD_fw,
       RE => RE_fw,
       RF => RF_fw,
       A_reg => A_reg,
       B_reg => B_reg,
       C_reg => C_reg,
       D_reg => D_reg,
       E_reg => E_reg,
       F_reg => F_reg,
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
       oddWB_Result => oddWB_Result,
       A => A,
       B => B,
       C => C,
       D => D,
       E => E,
       F => F
  );

I_cache : instruction_cache
  port map(
       clk => clk,
       PC => PC_if,
       A_instruction => instruction_A_if,
       A_hit => A_cache_hit,
       B_instruction => instruction_B_if,
       B_hit => B_cache_hit,
       mem_addr => instruction_mem_addr,
       mem_data => instruction_mem_data
  );

Instruction_mem : instruction_memory
  port map(
       addr => instruction_mem_addr,
       data => instruction_mem_data
  );

Issue_control : issue_control_unit
  port map(
       a_RegWr => a_RegWr,
       a_RegDst => a_RegDst,
       a_Latency => a_Latency,
       a_Unit => a_Unit,
       a_Imm => a_Imm,
       a_op_SFU1 => a_op_SFU1,
       a_op_SFU2 => a_op_SFU2,
       a_op_SPU => a_op_SPU,
       a_op_BU => a_op_BU,
       a_op_BRU => a_op_BRU,
       a_op_LSU => a_op_LSU,
       a_op_PU => a_op_PU,
       a_RA => a_RA,
       a_RA_rd => a_RA_rd,
       a_RB => a_RB,
       a_RB_rd => a_RB_rd,
       a_RC => a_RC,
       a_RC_rd => a_RC_rd,
       a_stop => a_stop,
       b_RegWr => b_RegWr,
       b_RegDst => b_RegDst,
       b_Latency => b_Latency,
       b_Unit => b_Unit,
       b_Imm => b_Imm,
       b_op_SFU1 => b_op_SFU1,
       b_op_SFU2 => b_op_SFU2,
       b_op_SPU => b_op_SPU,
       b_op_BU => b_op_BU,
       b_op_BRU => b_op_BRU,
       b_op_LSU => b_op_LSU,
       b_op_PU => b_op_PU,
       b_RA => b_RA,
       b_RA_rd => b_RA_rd,
       b_RB => b_RB,
       b_RB_rd => b_RB_rd,
       b_RC => b_RC,
       b_RC_rd => b_RC_rd,
       b_stop => b_stop,
       even5_RegDst => even5_RegDst,
       even5_RegWr => even5_RegWr,
       even5_Latency => even5_Latency,
       even0_RegDst => even0_RegDst,
       even0_RegWr => even0_RegWr,
       even0_Latency => even0_Latency,
       even1_RegDst => even1_RegDst,
       even1_RegWr => even1_RegWr,
       even1_Latency => even1_Latency,
       even2_RegDst => even2_RegDst,
       even2_RegWr => even2_RegWr,
       even2_Latency => even2_Latency,
       even3_RegDst => even3_RegDst,
       even3_RegWr => even3_RegWr,
       even3_Latency => even3_Latency,
       even4_RegDst => even4_RegDst,
       even4_RegWr => even4_RegWr,
       even4_Latency => even4_Latency,
       odd4_RegDst => odd4_RegDst,
       odd4_RegWr => odd4_RegWr,
       odd4_Latency => odd4_Latency,
       odd0_RegDst => odd0_RegDst,
       odd0_RegWr => odd0_RegWr,
       odd0_Latency => odd0_Latency,
       odd1_RegDst => odd1_RegDst,
       odd1_RegWr => odd1_RegWr,
       odd1_Latency => odd1_Latency,
       odd2_RegDst => odd2_RegDst,
       odd2_RegWr => odd2_RegWr,
       odd2_Latency => odd2_Latency,
       odd3_RegDst => odd3_RegDst,
       odd3_RegWr => odd3_RegWr,
       odd3_Latency => odd3_Latency,
       even_RegWr => even_RegWr_rf,
       even_RegDst => even_RegDst_rf,
       even_Latency => even_Latency_rf,
       even_Unit => even_Unit_rf,
       even_Imm => even_Imm_rf,
       op_SFU1 => op_SFU1_rf,
       op_SFU2 => op_SFU2_rf,
       op_SPU => op_SPU_rf,
       op_BU => op_BU_rf,
       RA => RA_rf,
       RB => RB_rf,
       RC => RC_rf,
       odd_RegWr => odd_RegWr_rf,
       odd_RegDst => odd_RegDst_rf,
       odd_Latency => odd_Latency_rf,
       odd_Unit => odd_Unit_rf,
       odd_Imm => odd_Imm_rf,
       op_BRU => op_BRU_rf,
       op_LSU => op_LSU_rf,
       op_PU => op_PU_rf,
       RD => RD_rf,
       RE => RE_rf,
       RF => RF_rf,
       a_fetch => a_fetch,
       b_fetch => b_fetch
  );

LSU : local_store_unit
  port map(
       clk => clk,
       op_sel => op_LSU,
       A => D,
       B => E,
       T => F,
       Imm => odd_Imm,
       Result => LSU_Result
  );

LSU_MUX : result_mux
  generic map(
       G_UNIT => UNIT_LOCAL_STORE,
       G_LATENCY => 6
  )
  port map(
       Unit_sel => odd6_Unit,
       Latency => odd6_Latency,
       Result0 => odd6_Result,
       Result1 => LSU_Result6,
       Result => odd6_Result_MUX
  );

LSU_pipe1 : result_reg
  port map(
       clk => clk,
       d => LSU_Result,
       q => LSU_Result1
  );

LSU_pipe2 : result_reg
  port map(
       clk => clk,
       d => LSU_Result1,
       q => LSU_Result2
  );

LSU_pipe3 : result_reg
  port map(
       clk => clk,
       d => LSU_Result2,
       q => LSU_Result3
  );

LSU_pipe4 : result_reg
  port map(
       clk => clk,
       d => LSU_Result3,
       q => LSU_Result4
  );

LSU_pipe5 : result_reg
  port map(
       clk => clk,
       d => LSU_Result4,
       q => LSU_Result5
  );

LSU_pipe6 : result_reg
  port map(
       clk => clk,
       d => LSU_Result5,
       q => LSU_Result6
  );

Odd_RF : odd_rf_reg
  port map(
       clk => clk,
       gate_n => branch_mispredict,
       Unit_d => odd_Unit_rf,
       Latency_d => odd_Latency_rf,
       RegDst_d => odd_RegDst_rf,
       RegWr_d => odd_RegWr_rf,
       op_LSU_d => op_LSU_rf,
       op_PU_d => op_PU_rf,
       op_BRU_d => op_BRU_rf,
       PC_d => PC_rf,
       Imm_d => odd_Imm_rf,
       RD_d => RD_rf,
       RE_d => RE_rf,
       RF_d => RF_rf,
       Unit_q => odd0_Unit,
       Latency_q => odd0_Latency,
       RegDst_q => odd0_RegDst,
       RegWr_q => odd0_RegWr,
       op_LSU_q => op_LSU,
       op_PU_q => op_PU,
       op_BRU_q => op_BRU,
       PC_q => PC_fw,
       Imm_q => odd_Imm,
       RD_q => RD_fw,
       RE_q => RE_fw,
       RF_q => RF_fw
  );

Odd_WB : pipe_reg
  port map(
       clk => clk,
       Result_d => odd7_Result,
       Unit_d => odd7_Unit,
       Latency_d => odd7_Latency,
       RegDst_d => odd7_RegDst,
       RegWr_d => odd7_RegWr,
       Result_q => oddWB_Result,
       Unit_q => oddWB_Unit,
       Latency_q => oddWB_Latency,
       RegDst_q => oddWB_RegDst,
       RegWr_q => oddWB_RegWr
  );

Odd_pipe1 : pipe_reg
  port map(
       clk => clk,
       Result_d => GND_128,
       Unit_d => odd0_Unit,
       Latency_d => odd0_Latency,
       RegDst_d => odd0_RegDst,
       RegWr_d => odd0_RegWr,
       Result_q => odd1_Result,
       Unit_q => odd1_Unit,
       Latency_q => odd1_Latency,
       RegDst_q => odd1_RegDst,
       RegWr_q => odd1_RegWr
  );

Odd_pipe2 : pipe_reg
  port map(
       clk => clk,
       Result_d => odd1_Result,
       Unit_d => odd1_Unit,
       Latency_d => odd1_Latency,
       RegDst_d => odd1_RegDst,
       RegWr_d => odd1_RegWr,
       Result_q => odd2_Result,
       Unit_q => odd2_Unit,
       Latency_q => odd2_Latency,
       RegDst_q => odd2_RegDst,
       RegWr_q => odd2_RegWr
  );

Odd_pipe3 : pipe_reg
  port map(
       clk => clk,
       Result_d => odd2_Result,
       Unit_d => odd2_Unit,
       Latency_d => odd2_Latency,
       RegDst_d => odd2_RegDst,
       RegWr_d => odd2_RegWr,
       Result_q => odd3_Result,
       Unit_q => odd3_Unit,
       Latency_q => odd3_Latency,
       RegDst_q => odd3_RegDst,
       RegWr_q => odd3_RegWr
  );

Odd_pipe4 : pipe_reg
  port map(
       clk => clk,
       Result_d => odd3_Result_MUX,
       Unit_d => odd3_Unit,
       Latency_d => odd3_Latency,
       RegDst_d => odd3_RegDst,
       RegWr_d => odd3_RegWr,
       Result_q => odd4_Result,
       Unit_q => odd4_Unit,
       Latency_q => odd4_Latency,
       RegDst_q => odd4_RegDst,
       RegWr_q => odd4_RegWr
  );

Odd_pipe5 : pipe_reg
  port map(
       clk => clk,
       Result_d => odd4_Result,
       Unit_d => odd4_Unit,
       Latency_d => odd4_Latency,
       RegDst_d => odd4_RegDst,
       RegWr_d => odd4_RegWr,
       Result_q => odd5_Result,
       Unit_q => odd5_Unit,
       Latency_q => odd5_Latency,
       RegDst_q => odd5_RegDst,
       RegWr_q => odd5_RegWr
  );

Odd_pipe6 : pipe_reg
  port map(
       clk => clk,
       Result_d => odd5_Result,
       Unit_d => odd5_Unit,
       Latency_d => odd5_Latency,
       RegDst_d => odd5_RegDst,
       RegWr_d => odd5_RegWr,
       Result_q => odd6_Result,
       Unit_q => odd6_Unit,
       Latency_q => odd6_Latency,
       RegDst_q => odd6_RegDst,
       RegWr_q => odd6_RegWr
  );

Odd_pipe7 : pipe_reg
  port map(
       clk => clk,
       Result_d => odd6_Result_MUX,
       Unit_d => odd6_Unit,
       Latency_d => odd6_Latency,
       RegDst_d => odd6_RegDst,
       RegWr_d => odd6_RegWr,
       Result_q => odd7_Result,
       Unit_q => odd7_Unit,
       Latency_q => odd7_Latency,
       RegDst_q => odd7_RegDst,
       RegWr_q => odd7_RegWr
  );

PC : program_counter
  port map(
       clk => clk,
       PC_i => PC_d,
       PCWr => PCWr,
       PC_o => PC_if,
       en => PC_en,
       inc2 => PC_inc2
  );

PU : permute_unit
  port map(
       op_sel => op_PU,
       A => D,
       Result => PU_Result
  );

PU_MUX : result_mux
  generic map(
       G_UNIT => UNIT_PERMUTE,
       G_LATENCY => 4
  )
  port map(
       Unit_sel => odd3_Unit,
       Latency => odd3_Latency,
       Result0 => odd3_Result,
       Result1 => PU_Result3,
       Result => odd3_Result_MUX
  );

PU_pipe1 : result_reg
  port map(
       clk => clk,
       d => PU_Result,
       q => PU_Result1
  );

PU_pipe2 : result_reg
  port map(
       clk => clk,
       d => PU_Result1,
       q => PU_Result2
  );

PU_pipe3 : result_reg
  port map(
       clk => clk,
       d => PU_Result2,
       q => PU_Result3
  );

Registers : register_file
  port map(
       clk => clk,
       A_rd_addr => RA_rf,
       A_rd_data => A_reg,
       B_rd_addr => RB_rf,
       B_rd_data => B_reg,
       C_rd_addr => RC_rf,
       C_rd_data => C_reg,
       D_rd_addr => RD_rf,
       D_rd_data => D_reg,
       E_rd_addr => RE_rf,
       E_rd_data => E_reg,
       F_rd_addr => RF_rf,
       F_rd_data => F_reg,
       A_wr_en => evenWB_RegWr,
       A_wr_addr => evenWB_RegDst,
       A_wr_data => evenWB_Result,
       B_wr_en => oddWB_RegWr,
       B_wr_addr => oddWB_RegDst,
       B_wr_data => oddWB_Result
  );

SFU1 : simple_fixed_unit1
  port map(
       op_sel => op_SFU1,
       A => A,
       B => B,
       Imm => even_Imm,
       Result => SFU1_Result
  );

SFU1_MUX : result_mux
  generic map(
       G_UNIT => UNIT_SIMPLE_FIXED1,
       G_LATENCY => 2
  )
  port map(
       Unit_sel => even2_Unit,
       Latency => even2_Latency,
       Result0 => even2_Result,
       Result1 => SFU1_Result2,
       Result => even2_Result_MUX
  );

SFU1_pipe1 : result_reg
  port map(
       clk => clk,
       d => SFU1_Result,
       q => SFU1_Result1
  );

SFU1_pipe2 : result_reg
  port map(
       clk => clk,
       d => SFU1_Result1,
       q => SFU1_Result2
  );

SFU2 : simple_fixed_unit2
  port map(
       op_sel => op_SFU2,
       A => A,
       B => B,
       Imm => even_Imm,
       Result => SFU2_Result
  );

SFU2_MUX : result_mux
  generic map(
       G_UNIT => UNIT_SIMPLE_FIXED2,
       G_LATENCY => 4
  )
  port map(
       Unit_sel => even3_Unit,
       Latency => even3_Latency,
       Result0 => even3_Result,
       Result1 => SFU_Result3,
       Result => even3_Result_MUX1
  );

SFU2_pipe1 : result_reg
  port map(
       clk => clk,
       d => SFU2_Result,
       q => SFU2_Result1
  );

SFU2_pipe2 : result_reg
  port map(
       clk => clk,
       d => SFU2_Result1,
       q => SFU2_Result2
  );

SFU2_pipe3 : result_reg
  port map(
       clk => clk,
       d => SFU2_Result2,
       q => SFU_Result3
  );

SPU : single_precision_unit
  port map(
       op_sel => op_SPU,
       A => A,
       B => B,
       C => C,
       Imm => even_Imm,
       Result => SPU_Result
  );

SPU_MUX1 : result_mux
  generic map(
       G_UNIT => UNIT_SINGLE_PRECISION,
       G_LATENCY => 6
  )
  port map(
       Unit_sel => even6_Unit,
       Latency => even6_Latency,
       Result0 => even6_Result,
       Result1 => SPU_Result6,
       Result => even6_Result_MUX
  );

SPU_MUX2 : result_mux
  generic map(
       G_UNIT => UNIT_SINGLE_PRECISION,
       G_LATENCY => 7
  )
  port map(
       Unit_sel => even7_Unit,
       Latency => even7_Latency,
       Result0 => even7_Result,
       Result1 => SPU_Result7,
       Result => even7_Result_MUX
  );

SPU_pipe1 : result_reg
  port map(
       clk => clk,
       d => SPU_Result,
       q => SPU_Result1
  );

SPU_pipe2 : result_reg
  port map(
       clk => clk,
       d => SPU_Result1,
       q => SPU_Result2
  );

SPU_pipe3 : result_reg
  port map(
       clk => clk,
       d => SPU_Result2,
       q => SPU_Result3
  );

SPU_pipe4 : result_reg
  port map(
       clk => clk,
       d => SPU_Result3,
       q => SPU_Result4
  );

SPU_pipe5 : result_reg
  port map(
       clk => clk,
       d => SPU_Result4,
       q => SPU_Result5
  );

SPU_pipe6 : result_reg
  port map(
       clk => clk,
       d => SPU_Result5,
       q => SPU_Result6
  );

SPU_pipe7 : result_reg
  port map(
       clk => clk,
       d => SPU_Result6,
       q => SPU_Result7
  );

stall_B <= not(B_cache_hit) or A_cache_hit_n;

PC_en <= A_cache_hit_q and a_fetch;

PC_inc2 <= B_cache_hit_q and b_fetch;

A_cache_hit_n <= not(A_cache_hit);


---- Power , ground assignment ----

GND <= GND_CONSTANT;
GND_128(0) <= GND;
GND_128(1) <= GND;
GND_128(2) <= GND;
GND_128(3) <= GND;
GND_128(4) <= GND;
GND_128(5) <= GND;
GND_128(6) <= GND;
GND_128(7) <= GND;
GND_128(8) <= GND;
GND_128(9) <= GND;
GND_128(10) <= GND;
GND_128(11) <= GND;
GND_128(12) <= GND;
GND_128(13) <= GND;
GND_128(14) <= GND;
GND_128(15) <= GND;
GND_128(16) <= GND;
GND_128(17) <= GND;
GND_128(18) <= GND;
GND_128(19) <= GND;
GND_128(20) <= GND;
GND_128(21) <= GND;
GND_128(22) <= GND;
GND_128(23) <= GND;
GND_128(24) <= GND;
GND_128(25) <= GND;
GND_128(26) <= GND;
GND_128(27) <= GND;
GND_128(28) <= GND;
GND_128(29) <= GND;
GND_128(30) <= GND;
GND_128(31) <= GND;
GND_128(32) <= GND;
GND_128(33) <= GND;
GND_128(34) <= GND;
GND_128(35) <= GND;
GND_128(36) <= GND;
GND_128(37) <= GND;
GND_128(38) <= GND;
GND_128(39) <= GND;
GND_128(40) <= GND;
GND_128(41) <= GND;
GND_128(42) <= GND;
GND_128(43) <= GND;
GND_128(44) <= GND;
GND_128(45) <= GND;
GND_128(46) <= GND;
GND_128(47) <= GND;
GND_128(48) <= GND;
GND_128(49) <= GND;
GND_128(50) <= GND;
GND_128(51) <= GND;
GND_128(52) <= GND;
GND_128(53) <= GND;
GND_128(54) <= GND;
GND_128(55) <= GND;
GND_128(56) <= GND;
GND_128(57) <= GND;
GND_128(58) <= GND;
GND_128(59) <= GND;
GND_128(60) <= GND;
GND_128(61) <= GND;
GND_128(62) <= GND;
GND_128(63) <= GND;
GND_128(64) <= GND;
GND_128(65) <= GND;
GND_128(66) <= GND;
GND_128(67) <= GND;
GND_128(68) <= GND;
GND_128(69) <= GND;
GND_128(70) <= GND;
GND_128(71) <= GND;
GND_128(72) <= GND;
GND_128(73) <= GND;
GND_128(74) <= GND;
GND_128(75) <= GND;
GND_128(76) <= GND;
GND_128(77) <= GND;
GND_128(78) <= GND;
GND_128(79) <= GND;
GND_128(80) <= GND;
GND_128(81) <= GND;
GND_128(82) <= GND;
GND_128(83) <= GND;
GND_128(84) <= GND;
GND_128(85) <= GND;
GND_128(86) <= GND;
GND_128(87) <= GND;
GND_128(88) <= GND;
GND_128(89) <= GND;
GND_128(90) <= GND;
GND_128(91) <= GND;
GND_128(92) <= GND;
GND_128(93) <= GND;
GND_128(94) <= GND;
GND_128(95) <= GND;
GND_128(96) <= GND;
GND_128(97) <= GND;
GND_128(98) <= GND;
GND_128(99) <= GND;
GND_128(100) <= GND;
GND_128(101) <= GND;
GND_128(102) <= GND;
GND_128(103) <= GND;
GND_128(104) <= GND;
GND_128(105) <= GND;
GND_128(106) <= GND;
GND_128(107) <= GND;
GND_128(108) <= GND;
GND_128(109) <= GND;
GND_128(110) <= GND;
GND_128(111) <= GND;
GND_128(112) <= GND;
GND_128(113) <= GND;
GND_128(114) <= GND;
GND_128(115) <= GND;
GND_128(116) <= GND;
GND_128(117) <= GND;
GND_128(118) <= GND;
GND_128(119) <= GND;
GND_128(120) <= GND;
GND_128(121) <= GND;
GND_128(122) <= GND;
GND_128(123) <= GND;
GND_128(124) <= GND;
GND_128(125) <= GND;
GND_128(126) <= GND;
GND_128(127) <= GND;

end rtl;
