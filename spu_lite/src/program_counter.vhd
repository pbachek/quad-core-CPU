library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
port(
    clk   : in  std_logic;

    en    : in  std_logic;
    inc2  : in  std_logic;
    PC_i  : in  std_logic_vector(0 to 31);
    PCWr  : in  std_logic;
    PC_o  : out std_logic_vector(0 to 31)
);
end entity;

architecture rtl of program_counter is

    signal PC : unsigned(0 to 31) := (others => '0');

begin

    PC_o <= PC_i when PCWr else
            std_logic_vector(PC + 8) when en and inc2 else
            std_logic_vector(PC + 4) when en else
            std_logic_vector(PC);

    PC <= unsigned(PC_o) when rising_edge(clk);

end architecture;