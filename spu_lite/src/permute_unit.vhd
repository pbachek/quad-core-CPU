library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity permute_unit is
port(
    op_sel : in  std_logic_vector(0 to 1);
    A      : in  std_logic_vector(0 to 127);
    Result : out std_logic_vector(0 to 127)
);
end entity;

architecture rtl of permute_unit is

signal op : permute_unit_op_t;

begin

op <= permute_unit_op_t'val(to_integer(unsigned(op_sel)));

process(all)
begin
    case op is
    when OP_GATHER_BITS_FROM_BYTES =>
        Result(0 to 15) <= (others => '0');
        Result(32 to 127) <= (others => '0');
        for i in 0 to 15 loop
            Result(i+16) <= A(8*i+7);
        end loop;
    when OP_GATHER_BITS_FROM_HALFWORDS =>
        Result(0 to 23) <= (others => '0');
        Result(32 to 127) <= (others => '0');
        for i in 0 to 7 loop
            Result(i+24) <= A(16*i+15);
        end loop;
    when OP_GATHER_BITS_FROM_WORDS =>
        Result(0 to 27) <= (others => '0');
        Result(32 to 127) <= (others => '0');
        for i in 0 to 3 loop
            Result(i+28) <= A(32*i+31);
        end loop;
    end case;
end process;

end architecture;