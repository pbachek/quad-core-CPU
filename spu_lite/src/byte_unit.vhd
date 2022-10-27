library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spu_lite;
use spu_lite.spu_lite_pkg.all;

entity byte_unit is
port(
    op_sel : in  std_logic_vector(0 to 1);
    A      : in  std_logic_vector(0 to 127);
    B      : in  std_logic_vector(0 to 127);
    Result : out std_logic_vector(0 to 127)
);
end entity;

architecture rtl of byte_unit is

function count_ones(s : std_logic_vector) return natural is
    variable r : natural := 0;
begin
    for i in s'range loop
        r := r + 1 when s(i);
    end loop;
    return r;
end function;

signal op : byte_unit_op_t;

begin

op <= byte_unit_op_t'val(to_integer(unsigned(op_sel)));

process(all)
begin
    case op is
    when OP_COUNT_ONES_IN_BYTES =>
        for i in 0 to 15 loop
            Result(i*8 to i*8+7) <= std_logic_vector(to_unsigned(count_ones(A(i*8 to i*8+7)), 8));
        end loop;
    when OP_AVERAGE_BYTES =>
        for i in 0 to 15 loop
            Result(i*8 to i*8+7) <= std_logic_vector(resize(shift_right(unsigned("0"&A(i*8 to i*8+7)) + unsigned("0"&B(i*8 to i*8+7)) + 1, 1), 8));
        end loop;
    when OP_ABSOLUTE_DIFFERENCE_OF_BYTES =>
        for i in 0 to 15 loop
            if unsigned(A(i*8 to i*8+7)) > unsigned(B(i*8 to i*8+7)) then
                Result(i*8 to i*8+7) <= std_logic_vector(unsigned(A(i*8 to i*8+7)) - unsigned(B(i*8 to i*8+7)));
            else
                Result(i*8 to i*8+7) <= std_logic_vector(unsigned(B(i*8 to i*8+7)) - unsigned(A(i*8 to i*8+7)));
            end if;
        end loop;
    when OP_SUM_BYTES_INTO_HALFWORDS =>
        Result(0 to 15) <= std_logic_vector(resize(unsigned(B(0 to 7)), 16) + unsigned(B(8 to 15)) + unsigned(B(16 to 23)) + unsigned(B(24 to 31)));
        Result(16 to 31) <= std_logic_vector(resize(unsigned(A(0 to 7)), 16) + unsigned(A(8 to 15)) + unsigned(A(16 to 23)) + unsigned(A(24 to 31)));
        Result(32 to 47) <= std_logic_vector(resize(unsigned(B(32 to 39)), 16) + unsigned(B(40 to 47)) + unsigned(B(48 to 55)) + unsigned(B(54 to 63)));
        Result(48 to 63) <= std_logic_vector(resize(unsigned(A(32 to 39)), 16) + unsigned(A(40 to 47)) + unsigned(A(48 to 55)) + unsigned(A(54 to 63)));
        Result(64 to 79) <= std_logic_vector(resize(unsigned(B(64 to 71)), 16) + unsigned(B(72 to 79)) + unsigned(B(80 to 87)) + unsigned(B(88 to 95)));
        Result(80 to 95) <= std_logic_vector(resize(unsigned(A(64 to 71)), 16) + unsigned(A(72 to 79)) + unsigned(A(80 to 87)) + unsigned(A(88 to 95)));
        Result(96 to 111) <= std_logic_vector(resize(unsigned(B(96 to 103)), 16) + unsigned(B(104 to 111)) + unsigned(B(112 to 119)) + unsigned(B(120 to 127)));
        Result(112 to 127) <= std_logic_vector(resize(unsigned(A(96 to 103)), 16) + unsigned(A(104 to 111)) + unsigned(A(112 to 119)) + unsigned(A(120 to 127)));
    end case;
end process;

end architecture;