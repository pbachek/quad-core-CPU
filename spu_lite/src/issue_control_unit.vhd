library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity issue_control_unit is
port(
    a_RegWr        : in  std_logic;
    a_RegDst       : in  std_logic_vector(0 to 6);
    a_Latency      : in  std_logic_vector(0 to 2);
    a_Unit         : in  std_logic_vector(0 to 2);
    a_Imm          : in  std_logic_vector(0 to 17);
    a_op_SFU1      : in  std_logic_vector(0 to 4);
    a_op_SFU2      : in  std_logic_vector(0 to 2);
    a_op_SPU       : in  std_logic_vector(0 to 3);
    a_op_BU        : in  std_logic_vector(0 to 1);
    a_op_BRU       : in  std_logic_vector(0 to 2);
    a_op_LSU       : in  std_logic_vector(0 to 3);
    a_op_PU        : in  std_logic_vector(0 to 1);
    a_RA           : in  std_logic_vector(0 to 6);
    a_RA_rd        : in  std_logic;
    a_RB           : in  std_logic_vector(0 to 6);
    a_RB_rd        : in  std_logic;
    a_RC           : in  std_logic_vector(0 to 6);
    a_RC_rd        : in  std_logic;
    a_stop         : in  std_logic;
    a_fetch        : out std_logic;

    b_RegWr        : in  std_logic;
    b_RegDst       : in  std_logic_vector(0 to 6);
    b_Latency      : in  std_logic_vector(0 to 2);
    b_Unit         : in  std_logic_vector(0 to 2);
    b_Imm          : in  std_logic_vector(0 to 17);
    b_op_SFU1      : in  std_logic_vector(0 to 4);
    b_op_SFU2      : in  std_logic_vector(0 to 2);
    b_op_SPU       : in  std_logic_vector(0 to 3);
    b_op_BU        : in  std_logic_vector(0 to 1);
    b_op_BRU       : in  std_logic_vector(0 to 2);
    b_op_LSU       : in  std_logic_vector(0 to 3);
    b_op_PU        : in  std_logic_vector(0 to 1);
    b_RA           : in  std_logic_vector(0 to 6);
    b_RA_rd        : in  std_logic;
    b_RB           : in  std_logic_vector(0 to 6);
    b_RB_rd        : in  std_logic;
    b_RC           : in  std_logic_vector(0 to 6);
    b_RC_rd        : in  std_logic;
    b_stop         : in  std_logic;
    b_fetch        : out std_logic;

    even0_RegDst   : in  std_logic_vector(0 to 6);
    even0_RegWr    : in  std_logic;
    even0_Latency  : in  std_logic_vector(0 to 2);
    even1_RegDst   : in  std_logic_vector(0 to 6);
    even1_RegWr    : in  std_logic;
    even1_Latency  : in  std_logic_vector(0 to 2);
    even2_RegDst   : in  std_logic_vector(0 to 6);
    even2_RegWr    : in  std_logic;
    even2_Latency  : in  std_logic_vector(0 to 2);
    even3_RegDst   : in  std_logic_vector(0 to 6);
    even3_RegWr    : in  std_logic;
    even3_Latency  : in  std_logic_vector(0 to 2);
    even4_RegDst   : in  std_logic_vector(0 to 6);
    even4_RegWr    : in  std_logic;
    even4_Latency  : in  std_logic_vector(0 to 2);
    even5_RegDst   : in  std_logic_vector(0 to 6);
    even5_RegWr    : in  std_logic;
    even5_Latency  : in  std_logic_vector(0 to 2);

    odd0_RegDst    : in  std_logic_vector(0 to 6);
    odd0_RegWr     : in  std_logic;
    odd0_Latency   : in  std_logic_vector(0 to 2);
    odd1_RegDst    : in  std_logic_vector(0 to 6);
    odd1_RegWr     : in  std_logic;
    odd1_Latency   : in  std_logic_vector(0 to 2);
    odd2_RegDst    : in  std_logic_vector(0 to 6);
    odd2_RegWr     : in  std_logic;
    odd2_Latency   : in  std_logic_vector(0 to 2);
    odd3_RegDst    : in  std_logic_vector(0 to 6);
    odd3_RegWr     : in  std_logic;
    odd3_Latency   : in  std_logic_vector(0 to 2);
    odd4_RegDst    : in  std_logic_vector(0 to 6);
    odd4_RegWr     : in  std_logic;
    odd4_Latency   : in  std_logic_vector(0 to 2);

	even_RegWr     : out std_logic;
	even_RegDst    : out std_logic_vector(0 to 6);
	even_Latency   : out std_logic_vector(0 to 2);
	even_Unit      : out std_logic_vector(0 to 2);
	even_Imm       : out std_logic_vector(0 to 17);
	op_SFU1        : out std_logic_vector(0 to 4);
	op_SFU2        : out std_logic_vector(0 to 2);
	op_SPU         : out std_logic_vector(0 to 3);
	op_BU          : out std_logic_vector(0 to 1);
	RA             : out std_logic_vector(0 to 6);
	RB             : out std_logic_vector(0 to 6);
	RC             : out std_logic_vector(0 to 6);

	odd_RegWr      : out std_logic;
	odd_RegDst     : out std_logic_vector(0 to 6);
	odd_Latency    : out std_logic_vector(0 to 2);
	odd_Unit       : out std_logic_vector(0 to 2);
	odd_Imm        : out std_logic_vector(0 to 15);
	op_BRU         : out std_logic_vector(0 to 2);
	op_LSU         : out std_logic_vector(0 to 3);
	op_PU          : out std_logic_vector(0 to 1);
	RD             : out std_logic_vector(0 to 6);
	RE             : out std_logic_vector(0 to 6);
	RF             : out std_logic_vector(0 to 6)
);
end entity;

architecture rtl of issue_control_unit is

    signal a_rd_hazard : std_logic;
    signal b_rd_hazard : std_logic;
    signal wr_hazard : std_logic;

    signal a_even : std_logic;
    signal b_even : std_logic;

    -- 00: nop, 01: a, 10: b
    signal even_sel : std_logic_vector(0 to 1);
    signal odd_sel : std_logic_vector(0 to 1);

begin

    a_rd_hazard <= '1' when (even0_RegWr = '1' and unsigned(even0_Latency) > 1 and ((a_RA_rd = '1' and even0_RegDst = a_RA) or (a_RB_rd = '1' and even0_RegDst = a_RB) or (a_RC_rd = '1' and even0_RegDst = a_RC))) or
                            (even1_RegWr = '1' and unsigned(even1_Latency) > 2 and ((a_RA_rd = '1' and even1_RegDst = a_RA) or (a_RB_rd = '1' and even1_RegDst = a_RB) or (a_RC_rd = '1' and even1_RegDst = a_RC))) or
                            (even2_RegWr = '1' and unsigned(even2_Latency) > 3 and ((a_RA_rd = '1' and even2_RegDst = a_RA) or (a_RB_rd = '1' and even2_RegDst = a_RB) or (a_RC_rd = '1' and even2_RegDst = a_RC))) or
                            (even3_RegWr = '1' and unsigned(even3_Latency) > 4 and ((a_RA_rd = '1' and even3_RegDst = a_RA) or (a_RB_rd = '1' and even3_RegDst = a_RB) or (a_RC_rd = '1' and even3_RegDst = a_RC))) or
                            (even4_RegWr = '1' and unsigned(even4_Latency) > 5 and ((a_RA_rd = '1' and even4_RegDst = a_RA) or (a_RB_rd = '1' and even4_RegDst = a_RB) or (a_RC_rd = '1' and even4_RegDst = a_RC))) or
                            (even5_RegWr = '1' and unsigned(even5_Latency) > 6 and ((a_RA_rd = '1' and even5_RegDst = a_RA) or (a_RB_rd = '1' and even5_RegDst = a_RB) or (a_RC_rd = '1' and even5_RegDst = a_RC))) or
                            (odd0_RegWr = '1' and unsigned(odd0_Latency) > 1 and ((a_RA_rd = '1' and odd0_RegDst = a_RA) or (a_RB_rd = '1' and odd0_RegDst = a_RB) or (a_RC_rd = '1' and odd0_RegDst = a_RC))) or
                            (odd1_RegWr = '1' and unsigned(odd1_Latency) > 2 and ((a_RA_rd = '1' and odd1_RegDst = a_RA) or (a_RB_rd = '1' and odd1_RegDst = a_RB) or (a_RC_rd = '1' and odd1_RegDst = a_RC))) or
                            (odd2_RegWr = '1' and unsigned(odd2_Latency) > 3 and ((a_RA_rd = '1' and odd2_RegDst = a_RA) or (a_RB_rd = '1' and odd2_RegDst = a_RB) or (a_RC_rd = '1' and odd2_RegDst = a_RC))) or
                            (odd3_RegWr = '1' and unsigned(odd3_Latency) > 4 and ((a_RA_rd = '1' and odd3_RegDst = a_RA) or (a_RB_rd = '1' and odd3_RegDst = a_RB) or (a_RC_rd = '1' and odd3_RegDst = a_RC))) or
                            (odd4_RegWr = '1' and unsigned(odd4_Latency) > 5 and ((a_RA_rd = '1' and odd4_RegDst = a_RA) or (a_RB_rd = '1' and odd4_RegDst = a_RB) or (a_RC_rd = '1' and odd4_RegDst = a_RC))) else
                   '0';

    b_rd_hazard <= '1' when (a_RegWr = '1' and unsigned(a_Latency) > 0 and ((b_RA_rd = '1' and a_RegDst = b_RA) or (b_RB_rd = '1' and a_RegDst = b_RB) or (b_RC_rd = '1' and a_RegDst = b_RC))) or
                            (even0_RegWr = '1' and unsigned(even0_Latency) > 1 and ((b_RA_rd = '1' and even0_RegDst = b_RA) or (b_RB_rd = '1' and even0_RegDst = b_RB) or (b_RC_rd = '1' and even0_RegDst = b_RC))) or
                            (even1_RegWr = '1' and unsigned(even1_Latency) > 2 and ((b_RA_rd = '1' and even1_RegDst = b_RA) or (b_RB_rd = '1' and even1_RegDst = b_RB) or (b_RC_rd = '1' and even1_RegDst = b_RC))) or
                            (even2_RegWr = '1' and unsigned(even2_Latency) > 3 and ((b_RA_rd = '1' and even2_RegDst = b_RA) or (b_RB_rd = '1' and even2_RegDst = b_RB) or (b_RC_rd = '1' and even2_RegDst = b_RC))) or
                            (even3_RegWr = '1' and unsigned(even3_Latency) > 4 and ((b_RA_rd = '1' and even3_RegDst = b_RA) or (b_RB_rd = '1' and even3_RegDst = b_RB) or (b_RC_rd = '1' and even3_RegDst = b_RC))) or
                            (even4_RegWr = '1' and unsigned(even4_Latency) > 5 and ((b_RA_rd = '1' and even4_RegDst = b_RA) or (b_RB_rd = '1' and even4_RegDst = b_RB) or (b_RC_rd = '1' and even4_RegDst = b_RC))) or
                            (even5_RegWr = '1' and unsigned(even5_Latency) > 6 and ((b_RA_rd = '1' and even5_RegDst = b_RA) or (b_RB_rd = '1' and even5_RegDst = b_RB) or (b_RC_rd = '1' and even5_RegDst = b_RC))) or
                            (odd0_RegWr = '1' and unsigned(odd0_Latency) > 1 and ((b_RA_rd = '1' and odd0_RegDst = b_RA) or (b_RB_rd = '1' and odd0_RegDst = b_RB) or (b_RC_rd = '1' and odd0_RegDst = b_RC))) or
                            (odd1_RegWr = '1' and unsigned(odd1_Latency) > 2 and ((b_RA_rd = '1' and odd1_RegDst = b_RA) or (b_RB_rd = '1' and odd1_RegDst = b_RB) or (b_RC_rd = '1' and odd1_RegDst = b_RC))) or
                            (odd2_RegWr = '1' and unsigned(odd2_Latency) > 3 and ((b_RA_rd = '1' and odd2_RegDst = b_RA) or (b_RB_rd = '1' and odd2_RegDst = b_RB) or (b_RC_rd = '1' and odd2_RegDst = b_RC))) or
                            (odd3_RegWr = '1' and unsigned(odd3_Latency) > 4 and ((b_RA_rd = '1' and odd3_RegDst = b_RA) or (b_RB_rd = '1' and odd3_RegDst = b_RB) or (b_RC_rd = '1' and odd3_RegDst = b_RC))) or
                            (odd4_RegWr = '1' and unsigned(odd4_Latency) > 5 and ((b_RA_rd = '1' and odd4_RegDst = b_RA) or (b_RB_rd = '1' and odd4_RegDst = b_RB) or (b_RC_rd = '1' and odd4_RegDst = b_RC))) else
                   '0';

    wr_hazard <= '1' when a_RegWr = '1' and b_RegWr = '1' and a_RegDst = b_RegDst else '0';

    a_even <= '1' when unsigned(a_Unit) <= 3 else '0';
    b_even <= '1' when unsigned(b_Unit) <= 3 else '0';

    a_fetch <= '1' when even_sel = "01" or odd_sel = "01" else '0';
    b_fetch <= '1' when even_sel = "10" or odd_sel = "10" else '0';

    -- Control
    process(all)
    begin
        if a_even and b_even then -- both even
            odd_sel <= "00";
            if a_rd_hazard or a_stop then
                even_sel <= "00";
            elsif a_stop then
                even_sel <= "00";
            else
                even_sel <= "01";
            end if;
        elsif a_even and not b_even then -- a even b odd
            if a_rd_hazard or a_stop then
                even_sel <= "00";
                odd_sel <= "00";
            elsif b_rd_hazard or b_stop then
                even_sel <= "01";
                odd_sel <= "00";
            elsif wr_hazard then
                even_sel <= "01";
                odd_sel <= "00";
            else
                even_sel <= "01";
                odd_sel <= "10";
            end if;
        elsif not a_even and b_even then -- a odd b even
            if a_rd_hazard or a_stop then
                even_sel <= "00";
                odd_sel <= "00";
            elsif b_rd_hazard or b_stop then
                even_sel <= "00";
                odd_sel <= "01";
            elsif wr_hazard then
                even_sel <= "00";
                odd_sel <= "01";
            elsif or a_op_BRU then -- if a is branch operation
                even_sel <= "00";
                odd_sel <= "01";
            else
                even_sel <= "10";
                odd_sel <= "01";
            end if;
        elsif not a_even and not b_even then -- both odd
            even_sel <= "00";
            if a_rd_hazard or a_stop then
                odd_sel <= "00";
            else
                odd_sel <= "01";
            end if;
        end if;
    end process;

    -- Even MUX
    process(all)
    begin
        case even_sel is
        when "01" =>
            even_RegWr   <= a_RegWr;
            even_RegDst  <= a_RegDst;
            even_Latency <= a_Latency;
            even_Unit    <= a_Unit;
            even_Imm     <= a_Imm;
            op_SFU1      <= a_op_SFU1;
            op_SFU2      <= a_op_SFU2;
            op_SPU       <= a_op_SPU;
            op_BU        <= a_op_BU;
            RA           <= a_RA;
            RB           <= a_RB;
            RC           <= a_RC;
        when "10" =>
            even_RegWr   <= b_RegWr;
            even_RegDst  <= b_RegDst;
            even_Latency <= b_Latency;
            even_Unit    <= b_Unit;
            even_Imm     <= b_Imm;
            op_SFU1      <= b_op_SFU1;
            op_SFU2      <= b_op_SFU2;
            op_SPU       <= b_op_SPU;
            op_BU        <= b_op_BU;
            RA           <= b_RA;
            RB           <= b_RB;
            RC           <= b_RC;
        when others =>
            even_RegWr   <= '0';
            even_RegDst  <= (others => '0');
            even_Latency <= (others => '0');
            even_Unit    <= (others => '0');
            even_Imm     <= (others => '0');
            op_SFU1      <= (others => '0');
            op_SFU2      <= (others => '0');
            op_SPU       <= (others => '0');
            op_BU        <= (others => '0');
            RA           <= (others => '0');
            RB           <= (others => '0');
            RC           <= (others => '0');
        end case;
    end process;

    -- Odd MUX
    process(all)
    begin
        case odd_sel is
        when "01" =>
            odd_RegWr   <= a_RegWr;
            odd_RegDst  <= a_RegDst;
            odd_Latency <= a_Latency;
            odd_Unit    <= a_Unit;
            odd_Imm     <= a_Imm(2 to 17);
            op_BRU      <= a_op_BRU;
            op_LSU      <= a_op_LSU;
            op_PU       <= a_op_PU;
            RD          <= a_RA;
            RE          <= a_RB;
            RF          <= a_RC;
        when "10" =>
            odd_RegWr   <= b_RegWr;
            odd_RegDst  <= b_RegDst;
            odd_Latency <= b_Latency;
            odd_Unit    <= b_Unit;
            odd_Imm     <= b_Imm(2 to 17);
            op_BRU      <= b_op_BRU;
            op_LSU      <= b_op_LSU;
            op_PU       <= b_op_PU;
            RD          <= b_RA;
            RE          <= b_RB;
            RF          <= b_RC;
        when others =>
            odd_RegWr   <= '0';
            odd_RegDst  <= (others => '0');
            odd_Latency <= (others => '0');
            odd_Unit    <= (others => '0');
            odd_Imm     <= (others => '0');
            op_BRU      <= (others => '0');
            op_LSU      <= (others => '0');
            op_PU       <= (others => '0');
            RD          <= (others => '0');
            RE          <= (others => '0');
            RF          <= (others => '0');
        end case;
    end process;

end architecture;