library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding_unit is
port(
    RA             : in  std_logic_vector(0 to 6);
    RB             : in  std_logic_vector(0 to 6);
    RC             : in  std_logic_vector(0 to 6);
    RD             : in  std_logic_vector(0 to 6);
    RE             : in  std_logic_vector(0 to 6);
    RF             : in  std_logic_vector(0 to 6);

    A_reg          : in  std_logic_vector(0 to 127);
    B_reg          : in  std_logic_vector(0 to 127);
    C_reg          : in  std_logic_vector(0 to 127);
    D_reg          : in  std_logic_vector(0 to 127);
    E_reg          : in  std_logic_vector(0 to 127);
    F_reg          : in  std_logic_vector(0 to 127);

    even2_RegDst   : in  std_logic_vector(0 to 6);
    even2_RegWr    : in  std_logic;
    even2_Result   : in  std_logic_vector(0 to 127);
    even3_RegDst   : in  std_logic_vector(0 to 6);
    even3_RegWr    : in  std_logic;
    even3_Result   : in  std_logic_vector(0 to 127);
    even4_RegDst   : in  std_logic_vector(0 to 6);
    even4_RegWr    : in  std_logic;
    even4_Result   : in  std_logic_vector(0 to 127);
    even5_RegDst   : in  std_logic_vector(0 to 6);
    even5_RegWr    : in  std_logic;
    even5_Result   : in  std_logic_vector(0 to 127);
    even6_RegDst   : in  std_logic_vector(0 to 6);
    even6_RegWr    : in  std_logic;
    even6_Result   : in  std_logic_vector(0 to 127);
    even7_RegDst   : in  std_logic_vector(0 to 6);
    even7_RegWr    : in  std_logic;
    even7_Result   : in  std_logic_vector(0 to 127);
    evenWB_RegDst  : in  std_logic_vector(0 to 6);
    evenWB_RegWr   : in  std_logic;
    evenWB_Result  : in  std_logic_vector(0 to 127);

    odd4_RegDst    : in  std_logic_vector(0 to 6);
    odd4_RegWr     : in  std_logic;
    odd4_Result    : in  std_logic_vector(0 to 127);
    odd5_RegDst    : in  std_logic_vector(0 to 6);
    odd5_RegWr     : in  std_logic;
    odd5_Result    : in  std_logic_vector(0 to 127);
    odd6_RegDst    : in  std_logic_vector(0 to 6);
    odd6_RegWr     : in  std_logic;
    odd6_Result    : in  std_logic_vector(0 to 127);
    odd7_RegDst    : in  std_logic_vector(0 to 6);
    odd7_RegWr     : in  std_logic;
    odd7_Result    : in  std_logic_vector(0 to 127);
    oddWB_RegDst   : in  std_logic_vector(0 to 6);
    oddWB_RegWr    : in  std_logic;
    oddWB_Result   : in  std_logic_vector(0 to 127);

    A              : out std_logic_vector(0 to 127);
    B              : out std_logic_vector(0 to 127);
    C              : out std_logic_vector(0 to 127);
    D              : out std_logic_vector(0 to 127);
    E              : out std_logic_vector(0 to 127);
    F              : out std_logic_vector(0 to 127)
);
end entity;

architecture rtl of forwarding_unit is
begin

    process(all)
    begin
        if RA = even2_RegDst and even2_RegWr = '1' then
            A <= even2_Result;
        elsif RA = even3_RegDst and even3_RegWr = '1' then
            A <= even3_Result;
        elsif RA = even4_RegDst and even4_RegWr = '1' then
            A <= even4_Result;
        elsif RA = odd4_RegDst and odd4_RegWr = '1' then
            A <= odd4_Result;
        elsif RA = even5_RegDst and even5_RegWr = '1' then
            A <= even5_Result;
        elsif RA = odd5_RegDst and odd5_RegWr = '1' then
            A <= odd5_Result;
        elsif RA = even6_RegDst and even6_RegWr = '1' then
            A <= even6_Result;
        elsif RA = odd6_RegDst and odd6_RegWr = '1' then
            A <= odd6_Result;
        elsif RA = even7_RegDst and even7_RegWr = '1' then
            A <= even7_Result;
        elsif RA = odd7_RegDst and odd7_RegWr = '1' then
            A <= odd7_Result;
        elsif RA = evenWB_RegDst and evenWB_RegWr = '1' then
            A <= evenWB_Result;
        elsif RA = oddWB_RegDst and oddWB_RegWr = '1' then
            A <= oddWB_Result;
        else
            A <= A_reg;
        end if;
    end process;

    process(all)
    begin
        if RB = even2_RegDst and even2_RegWr = '1' then
            B <= even2_Result;
        elsif RB = even3_RegDst and even3_RegWr = '1' then
            B <= even3_Result;
        elsif RB = even4_RegDst and even4_RegWr = '1' then
            B <= even4_Result;
        elsif RB = odd4_RegDst and odd4_RegWr = '1' then
            B <= odd4_Result;
        elsif RB = even5_RegDst and even5_RegWr = '1' then
            B <= even5_Result;
        elsif RB = odd5_RegDst and odd5_RegWr = '1' then
            B <= odd5_Result;
        elsif RB = even6_RegDst and even6_RegWr = '1' then
            B <= even6_Result;
        elsif RB = odd6_RegDst and odd6_RegWr = '1' then
            B <= odd6_Result;
        elsif RB = even7_RegDst and even7_RegWr = '1' then
            B <= even7_Result;
        elsif RB = odd7_RegDst and odd7_RegWr = '1' then
            B <= odd7_Result;
        elsif RB = evenWB_RegDst and evenWB_RegWr = '1' then
            B <= evenWB_Result;
        elsif RB = oddWB_RegDst and oddWB_RegWr = '1' then
            B <= oddWB_Result;
        else
            B <= B_reg;
        end if;
    end process;

    process(all)
    begin
        if RC = even2_RegDst and even2_RegWr = '1' then
            C <= even2_Result;
        elsif RC = even3_RegDst and even3_RegWr = '1' then
            C <= even3_Result;
        elsif RC = even4_RegDst and even4_RegWr = '1' then
            C <= even4_Result;
        elsif RC = odd4_RegDst and odd4_RegWr = '1' then
            C <= odd4_Result;
        elsif RC = even5_RegDst and even5_RegWr = '1' then
            C <= even5_Result;
        elsif RC = odd5_RegDst and odd5_RegWr = '1' then
            C <= odd5_Result;
        elsif RC = even6_RegDst and even6_RegWr = '1' then
            C <= even6_Result;
        elsif RC = odd6_RegDst and odd6_RegWr = '1' then
            C <= odd6_Result;
        elsif RC = even7_RegDst and even7_RegWr = '1' then
            C <= even7_Result;
        elsif RC = odd7_RegDst and odd7_RegWr = '1' then
            C <= odd7_Result;
        elsif RC = evenWB_RegDst and evenWB_RegWr = '1' then
            C <= evenWB_Result;
        elsif RC = oddWB_RegDst and oddWB_RegWr = '1' then
            C <= oddWB_Result;
        else
            C <= C_reg;
        end if;
    end process;

    process(all)
    begin
        if RD = even2_RegDst and even2_RegWr = '1' then
            D <= even2_Result;
        elsif RD = even3_RegDst and even3_RegWr = '1' then
            D <= even3_Result;
        elsif RD = even4_RegDst and even4_RegWr = '1' then
            D <= even4_Result;
        elsif RD = odd4_RegDst and odd4_RegWr = '1' then
            D <= odd4_Result;
        elsif RD = even5_RegDst and even5_RegWr = '1' then
            D <= even5_Result;
        elsif RD = odd5_RegDst and odd5_RegWr = '1' then
            D <= odd5_Result;
        elsif RD = even6_RegDst and even6_RegWr = '1' then
            D <= even6_Result;
        elsif RD = odd6_RegDst and odd6_RegWr = '1' then
            D <= odd6_Result;
        elsif RD = even7_RegDst and even7_RegWr = '1' then
            D <= even7_Result;
        elsif RD = odd7_RegDst and odd7_RegWr = '1' then
            D <= odd7_Result;
        elsif RD = evenWB_RegDst and evenWB_RegWr = '1' then
            D <= evenWB_Result;
        elsif RD = oddWB_RegDst and oddWB_RegWr = '1' then
            D <= oddWB_Result;
        else
            D <= D_reg;
        end if;
    end process;

    process(all)
    begin
        if RE = even2_RegDst and even2_RegWr = '1' then
            E <= even2_Result;
        elsif RE = even3_RegDst and even3_RegWr = '1' then
            E <= even3_Result;
        elsif RE = even4_RegDst and even4_RegWr = '1' then
            E <= even4_Result;
        elsif RE = odd4_RegDst and odd4_RegWr = '1' then
            E <= odd4_Result;
        elsif RE = even5_RegDst and even5_RegWr = '1' then
            E <= even5_Result;
        elsif RE = odd5_RegDst and odd5_RegWr = '1' then
            E <= odd5_Result;
        elsif RE = even6_RegDst and even6_RegWr = '1' then
            E <= even6_Result;
        elsif RE = odd6_RegDst and odd6_RegWr = '1' then
            E <= odd6_Result;
        elsif RE = even7_RegDst and even7_RegWr = '1' then
            E <= even7_Result;
        elsif RE = odd7_RegDst and odd7_RegWr = '1' then
            E <= odd7_Result;
        elsif RE = evenWB_RegDst and evenWB_RegWr = '1' then
            E <= evenWB_Result;
        elsif RE = oddWB_RegDst and oddWB_RegWr = '1' then
            E <= oddWB_Result;
        else
            E <= E_reg;
        end if;
    end process;

    process(all)
    begin
        if RF = even2_RegDst and even2_RegWr = '1' then
            F <= even2_Result;
        elsif RF = even3_RegDst and even3_RegWr = '1' then
            F <= even3_Result;
        elsif RF = even4_RegDst and even4_RegWr = '1' then
            F <= even4_Result;
        elsif RF = odd4_RegDst and odd4_RegWr = '1' then
            F <= odd4_Result;
        elsif RF = even5_RegDst and even5_RegWr = '1' then
            F <= even5_Result;
        elsif RF = odd5_RegDst and odd5_RegWr = '1' then
            F <= odd5_Result;
        elsif RF = even6_RegDst and even6_RegWr = '1' then
            F <= even6_Result;
        elsif RF = odd6_RegDst and odd6_RegWr = '1' then
            F <= odd6_Result;
        elsif RF = even7_RegDst and even7_RegWr = '1' then
            F <= even7_Result;
        elsif RF = odd7_RegDst and odd7_RegWr = '1' then
            F <= odd7_Result;
        elsif RF = evenWB_RegDst and evenWB_RegWr = '1' then
            F <= evenWB_Result;
        elsif RF = oddWB_RegDst and oddWB_RegWr = '1' then
            F <= oddWB_Result;
        else
            F <= F_reg;
        end if;
    end process;

end architecture;