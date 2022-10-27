library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

	-- Add your library and packages declaration here ...

entity spu_lite_tb is
end spu_lite_tb;

architecture TB_ARCHITECTURE of spu_lite_tb is
	-- Component declaration of the tested unit
	component quad_core_top is
	port(
		clk : in  std_logic
	);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...
    signal end_sim : boolean := false;

	type generic_mem_t is array (natural range <>) of std_logic_vector;

    alias mem is <<signal UUT.mem_controller_inst.shared_cache_inst.mem : generic_mem_t(0 to 4095)(0 to 511)>>;

    alias registers0 is <<signal UUT.core0.Registers.registers : generic_mem_t(0 to 127)(0 to 127)>>;
    alias registers1 is <<signal UUT.core1.Registers.registers : generic_mem_t(0 to 127)(0 to 127)>>;
    alias registers2 is <<signal UUT.core2.Registers.registers : generic_mem_t(0 to 127)(0 to 127)>>;
    alias registers3 is <<signal UUT.core3.Registers.registers : generic_mem_t(0 to 127)(0 to 127)>>;

	alias L1_cache0 is <<signal UUT.core0.cache_controller_inst.L1_cache_inst.mem : generic_mem_t(0 to 255)(0 to 511)>>;
	alias L1_cache1 is <<signal UUT.core1.cache_controller_inst.L1_cache_inst.mem : generic_mem_t(0 to 255)(0 to 511)>>;
	alias L1_cache2 is <<signal UUT.core2.cache_controller_inst.L1_cache_inst.mem : generic_mem_t(0 to 255)(0 to 511)>>;
	alias L1_cache3 is <<signal UUT.core3.cache_controller_inst.L1_cache_inst.mem : generic_mem_t(0 to 255)(0 to 511)>>;

	alias state_tag_table0 is <<signal UUT.core0.cache_controller_inst.state_tag_table : state_tag_table_t>>;
	alias state_tag_table1 is <<signal UUT.core1.cache_controller_inst.state_tag_table : state_tag_table_t>>;
	alias state_tag_table2 is <<signal UUT.core2.cache_controller_inst.state_tag_table : state_tag_table_t>>;
	alias state_tag_table3 is <<signal UUT.core3.cache_controller_inst.state_tag_table : state_tag_table_t>>;

begin

    process begin
        clk <= '0';
        while not end_sim loop
            wait for 500ps;
            clk <= not clk;
        end loop;
        wait;
    end process;

    process
        file text_var : text;
        variable line_var : line;
    begin
        -- Wait for program to complete
		wait for 2000ns;
        wait until rising_edge(clk);
        end_sim <= true;

        -- Dump memory to file
        file_open(text_var, "mem_dump.txt", write_mode);
        for i in mem'range loop
			for j in 0 to 3 loop
				write(line_var,to_hstring(mem(i)(128*j to 128*j + 127)));
            	writeline(text_var, line_var);
			end loop;
        end loop;
        file_close(text_var);

        -- Dump registers to file
        file_open(text_var, "reg_dump0.txt", write_mode);
        for i in registers0'range loop
            write(line_var, to_hstring(registers0(i)));
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);
        file_open(text_var, "reg_dump1.txt", write_mode);
        for i in registers1'range loop
            write(line_var, to_hstring(registers1(i)));
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);
        file_open(text_var, "reg_dump2.txt", write_mode);
        for i in registers2'range loop
            write(line_var, to_hstring(registers2(i)));
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);
        file_open(text_var, "reg_dump3.txt", write_mode);
        for i in registers3'range loop
            write(line_var, to_hstring(registers3(i)));
            writeline(text_var, line_var);
        end loop;
        file_close(text_var);

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

        report "Test Complete" & CR & LF;
        wait;
    end process;

	-- Unit Under Test port map
	UUT : quad_core_top
		port map (
			clk => clk
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;


