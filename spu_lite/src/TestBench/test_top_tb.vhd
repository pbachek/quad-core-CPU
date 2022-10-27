library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity test_top_tb is
end entity;

architecture rtl of test_top_tb is

	component test_top is
	port(
		clk             : in  std_logic;
		proc0_rd		: in  std_logic;
		proc0_wr		: in  std_logic;
		proc0_op_done	: out std_logic;
		proc0_ll		: in  std_logic;
		proc0_sc		: in  std_logic;
		proc0_addr		: in  std_logic_vector(0 to 13);
		proc0_wr_data	: in  std_logic_vector(0 to 127);
		proc0_rd_data	: out std_logic_vector(0 to 127);
		proc1_rd		: in  std_logic;
		proc1_wr		: in  std_logic;
		proc1_op_done	: out std_logic;
		proc1_ll		: in  std_logic;
		proc1_sc		: in  std_logic;
		proc1_addr		: in  std_logic_vector(0 to 13);
		proc1_wr_data	: in  std_logic_vector(0 to 127);
		proc1_rd_data	: out std_logic_vector(0 to 127);
		proc2_rd		: in  std_logic;
		proc2_wr		: in  std_logic;
		proc2_op_done	: out std_logic;
		proc2_ll		: in  std_logic;
		proc2_sc		: in  std_logic;
		proc2_addr		: in  std_logic_vector(0 to 13);
		proc2_wr_data	: in  std_logic_vector(0 to 127);
		proc2_rd_data	: out std_logic_vector(0 to 127);
		proc3_rd		: in  std_logic;
		proc3_wr		: in  std_logic;
		proc3_op_done	: out std_logic;
		proc3_ll		: in  std_logic;
		proc3_sc		: in  std_logic;
		proc3_addr		: in  std_logic_vector(0 to 13);
		proc3_wr_data	: in  std_logic_vector(0 to 127);
		proc3_rd_data	: out std_logic_vector(0 to 127)
	);
	end component;

	signal clk             :  std_logic;
	signal proc0_rd		:  std_logic;
	signal proc0_wr		:  std_logic;
	signal proc0_op_done	:  std_logic;
	signal proc0_ll		:  std_logic;
	signal proc0_sc		:  std_logic;
	signal proc0_addr		:  std_logic_vector(0 to 13);
	signal proc0_wr_data	:  std_logic_vector(0 to 127);
	signal proc0_rd_data	:  std_logic_vector(0 to 127);
	signal proc1_rd		:  std_logic;
	signal proc1_wr		:  std_logic;
	signal proc1_op_done	:  std_logic;
	signal proc1_ll		:  std_logic;
	signal proc1_sc		:  std_logic;
	signal proc1_addr		:  std_logic_vector(0 to 13);
	signal proc1_wr_data	:  std_logic_vector(0 to 127);
	signal proc1_rd_data	:  std_logic_vector(0 to 127);
	signal proc2_rd		:  std_logic;
	signal proc2_wr		:  std_logic;
	signal proc2_op_done	:  std_logic;
	signal proc2_ll		:  std_logic;
	signal proc2_sc		:  std_logic;
	signal proc2_addr		:  std_logic_vector(0 to 13);
	signal proc2_wr_data	:  std_logic_vector(0 to 127);
	signal proc2_rd_data	:  std_logic_vector(0 to 127);
	signal proc3_rd		:  std_logic;
	signal proc3_wr		:  std_logic;
	signal proc3_op_done	:  std_logic;
	signal proc3_ll		:  std_logic;
	signal proc3_sc		:  std_logic;
	signal proc3_addr		:  std_logic_vector(0 to 13);
	signal proc3_wr_data	:  std_logic_vector(0 to 127);
	signal proc3_rd_data	:  std_logic_vector(0 to 127);

	constant clock_period : time := 1ns;
	signal end_sim : boolean := false;

	type generic_mem_t is array (natural range <>) of std_logic_vector;
	alias L1_cache0 is <<signal test_top_inst.cache_controller0.L1_cache_inst.mem : generic_mem_t(0 to 255)(0 to 511)>>;
	alias L1_cache1 is <<signal test_top_inst.cache_controller1.L1_cache_inst.mem : generic_mem_t(0 to 255)(0 to 511)>>;
	alias L1_cache2 is <<signal test_top_inst.cache_controller2.L1_cache_inst.mem : generic_mem_t(0 to 255)(0 to 511)>>;
	alias L1_cache3 is <<signal test_top_inst.cache_controller3.L1_cache_inst.mem : generic_mem_t(0 to 255)(0 to 511)>>;
	alias shared_mem is <<signal test_top_inst.mem_controller_inst.shared_cache_inst.mem : generic_mem_t(0 to 4095)(0 to 511)>>;

	alias state_tag_table0 is <<signal test_top_inst.cache_controller0.state_tag_table : state_tag_table_t>>;
	alias state_tag_table1 is <<signal test_top_inst.cache_controller1.state_tag_table : state_tag_table_t>>;
	alias state_tag_table2 is <<signal test_top_inst.cache_controller2.state_tag_table : state_tag_table_t>>;
	alias state_tag_table3 is <<signal test_top_inst.cache_controller3.state_tag_table : state_tag_table_t>>;

begin

	process
	begin
		clk <= '0';
		while not end_sim loop
			wait for clock_period / 2;
			clk <= not clk;
		end loop;
		wait;
	end process;

	process
	begin
		proc0_rd		<= '0';
		proc0_wr		<= '0';
		proc0_ll		<= '0';
		proc0_sc		<= '0';
		proc0_addr		<= 14x"0000";
		proc0_wr_data	<= x"0000_0000_0000_0000_0000_0000_0000_0000";
		proc1_rd		<= '0';
		proc1_wr		<= '0';
		proc1_ll		<= '0';
		proc1_sc		<= '0';
		proc1_addr		<= 14x"0000";
		proc1_wr_data	<= x"0000_0000_0000_0000_0000_0000_0000_0000";
		proc2_rd		<= '0';
		proc2_wr		<= '0';
		proc2_ll		<= '0';
		proc2_sc		<= '0';
		proc2_addr		<= 14x"0000";
		proc2_wr_data	<= x"0000_0000_0000_0000_0000_0000_0000_0000";
		proc3_rd		<= '0';
		proc3_wr		<= '0';
		proc3_ll		<= '0';
		proc3_sc		<= '0';
		proc3_addr		<= 14x"0000";
		proc3_wr_data	<= x"0000_0000_0000_0000_0000_0000_0000_0000";
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		proc0_wr <= '1';
		proc0_addr <= 14x"0004";
		proc0_wr_data	<= x"1111_1111_1111_1111_1111_1111_1111_1111";
		proc1_wr <= '1';
		proc1_addr <= 14x"0005";
		proc1_wr_data	<= x"2222_2222_2222_2222_2222_2222_2222_2222";
		wait until rising_edge(clk);
		proc0_wr <= '0';
		proc1_wr <= '0';
		wait until proc0_op_done or proc1_op_done;
		wait until proc0_op_done or proc1_op_done;
		wait until rising_edge(clk);

		proc2_wr <= '1';
		proc2_addr <= 14x"0006";
		proc2_wr_data	<= x"3333_3333_3333_3333_3333_3333_3333_3333";
		proc3_wr <= '1';
		proc3_addr <= 14x"0007";
		proc3_wr_data	<= x"4444_4444_4444_4444_4444_4444_4444_4444";
		wait until rising_edge(clk);
		proc2_wr <= '0';
		proc3_wr <= '0';
		wait until proc2_op_done or proc3_op_done;
		wait until proc2_op_done or proc3_op_done;
		wait until rising_edge(clk);

		proc1_wr <= '1';
		proc1_addr <= 14x"0406";
		proc1_wr_data	<= x"BBBB_BBBB_BBBB_BBBB_BBBB_BBBB_BBBB_BBBB";
		wait until rising_edge(clk);
		proc1_wr <= '0';
		wait until proc1_op_done;
		wait until rising_edge(clk);

		proc3_rd <= '1';
		proc3_addr <= 14x"0405";
		wait until rising_edge(clk);
		proc3_rd <= '0';
		wait until proc3_op_done;
		wait until rising_edge(clk);

		for i in 0 to 50 loop
			wait until rising_edge(clk);
		end loop;
		end_sim <= true;
		wait;
	end process;

	process
        file text_var : text;
        variable line_var : line;
    begin
        -- Wait for stop signal
        wait until end_sim;

        -- Dump caches to file
        file_open(text_var, "cache_dump0.txt", write_mode);
        for i in L1_cache0'range loop
            write(line_var, to_hstring(L1_cache0(i)));
			case state_tag_table0(i).state is
			when modified_t => write(line_var, " M");
			when exclusive_t => write(line_var, " E");
			when shared_t => write(line_var, " S");
			when invalid_t => write(line_var, " I");
			end case;
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);

        file_open(text_var, "cache_dump1.txt", write_mode);
        for i in L1_cache1'range loop
            write(line_var, to_hstring(L1_cache1(i)));
			case state_tag_table1(i).state is
			when modified_t => write(line_var, " M");
			when exclusive_t => write(line_var, " E");
			when shared_t => write(line_var, " S");
			when invalid_t => write(line_var, " I");
			end case;
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);

        file_open(text_var, "cache_dump2.txt", write_mode);
        for i in L1_cache2'range loop
            write(line_var, to_hstring(L1_cache2(i)));
			case state_tag_table2(i).state is
			when modified_t => write(line_var, " M");
			when exclusive_t => write(line_var, " E");
			when shared_t => write(line_var, " S");
			when invalid_t => write(line_var, " I");
			end case;
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);

        file_open(text_var, "cache_dump3.txt", write_mode);
        for i in L1_cache3'range loop
            write(line_var, to_hstring(L1_cache3(i)));
			case state_tag_table3(i).state is
			when modified_t => write(line_var, " M");
			when exclusive_t => write(line_var, " E");
			when shared_t => write(line_var, " S");
			when invalid_t => write(line_var, " I");
			end case;
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);

        -- Dump shared memory to file
        file_open(text_var, "mem_dump.txt", write_mode);
        for i in shared_mem'range loop
			write(line_var, to_hstring(shared_mem(i)));
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);

        report "Test Complete" & CR & LF;
        wait;
    end process;

	test_top_inst : test_top
	port map(
		clk => clk,
		proc0_rd => proc0_rd,
		proc0_wr => proc0_wr,
		proc0_op_done => proc0_op_done,
		proc0_ll => proc0_ll,
		proc0_sc => proc0_sc,
		proc0_addr => proc0_addr,
		proc0_wr_data => proc0_wr_data,
		proc0_rd_data => proc0_rd_data,
		proc1_rd => proc1_rd,
		proc1_wr => proc1_wr,
		proc1_op_done => proc1_op_done,
		proc1_ll => proc1_ll,
		proc1_sc => proc1_sc,
		proc1_addr => proc1_addr,
		proc1_wr_data => proc1_wr_data,
		proc1_rd_data => proc1_rd_data,
		proc2_rd => proc2_rd,
		proc2_wr => proc2_wr,
		proc2_op_done => proc2_op_done,
		proc2_ll => proc2_ll,
		proc2_sc => proc2_sc,
		proc2_addr => proc2_addr,
		proc2_wr_data => proc2_wr_data,
		proc2_rd_data => proc2_rd_data,
		proc3_rd => proc3_rd,
		proc3_wr => proc3_wr,
		proc3_op_done => proc3_op_done,
		proc3_ll => proc3_ll,
		proc3_sc => proc3_sc,
		proc3_addr => proc3_addr,
		proc3_wr_data => proc3_wr_data,
		proc3_rd_data => proc3_rd_data
	);

end architecture;