library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_prediction_unit is
port(
    clk        : in  std_logic;

    PC_if      : in  std_logic_vector(0 to 31);
    PC_BRU     : in  std_logic_vector(0 to 31);
    PCWr_BRU   : in  std_logic;

    op_BRU_rf  : in  std_logic_vector(0 to 2);
    op_BRU_a   : in  std_logic_vector(0 to 2);
    mispredict : out std_logic;

    PC_br      : out std_logic_vector(0 to 31);
    PC_o       : out std_logic_vector(0 to 31);
    PCWr       : out std_logic
);
end entity;

architecture rtl of branch_prediction_unit is

    type branch_history_t is record
        taken  : std_logic;
        target : std_logic_vector(0 to 31);
    end record;
    type branch_history_table_t is array (0 to 2**16-1) of branch_history_t;
    signal branch_history_table : branch_history_table_t := (others => ('0', (others => '0')));

    signal PCWr_q1, PCWr_q2 : std_logic;
    signal PC_o_q1, PC_o_q2 : std_logic_vector(0 to 31);
    signal PC_br_q1, PC_br_q2 : std_logic_vector(0 to 31);
    signal branch_op, branch_op_q1, branch_op_q2 : std_logic;
    signal PC_dec : std_logic_vector(0 to 31):= (others => '0');

begin

    branch_op <= or op_BRU_rf;

    PC_br <= PC_dec when or op_BRU_a else std_logic_vector(unsigned(PC_dec) + 4);

    process(clk)
    begin
        if rising_edge(clk) then
            PC_dec <= PC_if;
            PCWr_q1 <= PCWr;
            PCWr_q2 <= PCWr_q1;
            PC_o_q1 <= PC_o;
            PC_o_q2 <= PC_o_q1;
            PC_br_q1 <= PC_br;
            PC_br_q2 <= PC_br_q1;
            branch_op_q1 <= branch_op;
            if mispredict then
                branch_op_q2 <= '0';
            else
                branch_op_q2 <= branch_op_q1;
            end if;
        end if;
    end process;

    process(all)
    begin
        -- Defaults
        mispredict <= '0';
        PCWr <= '0';
        PC_o <= (others => '0');
        -- Prediction
        if branch_op then
            (PCWr, PC_o) <= branch_history_table(to_integer(unsigned(PC_br(14 to 29))));
        end if;
        -- Misprediction check
        if branch_op_q2 then
            if PCWr_q2 = '0' then -- predicted not taken
                if PCWr_BRU = '1' then -- was taken
                    mispredict <= '1';
                    PCWr <= '1';
                    PC_o <= PC_BRU;
                end if;
            elsif PCWr_q2 = '1' then -- predicted taken
                if PCWr_BRU = '0' then -- was not taken
                    mispredict <= '1';
                    PCWr <= '1';
                    PC_o <= std_logic_vector(unsigned(PC_br_q2) + 4);
                elsif PC_o_q2 /= PC_BRU then -- address was wrong
                    mispredict <= '1';
                    PCWr <= '1';
                    PC_o <= PC_BRU;
                end if;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if branch_op_q2 then
                branch_history_table(to_integer(unsigned(PC_br_q2(14 to 29)))) <= (PCWr_BRU, PC_BRU);
            end if;
        end if;
    end process;

end architecture;