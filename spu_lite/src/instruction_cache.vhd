library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity instruction_cache is
port(
    clk              : in  std_logic;

    PC               : in  std_logic_vector(0 to 31);

    A_instruction    : out std_logic_vector(0 to 31);
    A_hit            : out std_logic;

    B_instruction    : out std_logic_vector(0 to 31);
    B_hit            : out std_logic;

    mem_addr         : out std_logic_vector(0 to 31) := (others => '0');
    mem_data         : in  std_logic_vector(0 to 7)
);
end entity;

architecture rtl of instruction_cache is

    constant CACHE_SIZE_BYTES : natural := 1024;
    constant BLOCK_SIZE_BYTES : natural := 256;
    constant NUM_ENTRIES : natural := CACHE_SIZE_BYTES / BLOCK_SIZE_BYTES;
    constant INDEX_WIDTH : natural := natural(ceil(log2(real(NUM_ENTRIES))));
    constant BLOCK_OFFSET_WIDTH : natural := natural(ceil(log2(real(BLOCK_SIZE_BYTES)))) - 2;
    constant TAG_WIDTH : natural := 30 - BLOCK_OFFSET_WIDTH - INDEX_WIDTH;

    type instruction_cache_entry_t is record
        valid : std_logic;
        tag   : std_logic_vector(0 to TAG_WIDTH - 1);
        data  : std_logic_vector(0 to (8 * BLOCK_SIZE_BYTES) - 1);
    end record;
    type instruction_cache_t is array (0 to NUM_ENTRIES - 1) of instruction_cache_entry_t;
    signal instruction_cache : instruction_cache_t := ((others => ('0', (others => '0'), (others => '0'))));

    signal A_addr, B_addr : std_logic_vector(0 to 31);
    signal A_index, B_index, mem_index : natural;
    signal A_offset, B_offset, mem_offset : natural;

    signal read_mem_block : std_logic := '0';

begin

    -- Compute address
    A_addr <= PC;
    B_addr <= std_logic_vector(unsigned(PC) + 4);

    -- Compute cache index
    A_index <= to_integer(unsigned(A_addr(TAG_WIDTH to TAG_WIDTH + INDEX_WIDTH - 1)));
    B_index <= to_integer(unsigned(B_addr(TAG_WIDTH to TAG_WIDTH + INDEX_WIDTH - 1)));

    -- Compute block offset
    A_offset <= to_integer(unsigned(A_addr(30 - BLOCK_OFFSET_WIDTH to 29)));
    B_offset <= to_integer(unsigned(B_addr(30 - BLOCK_OFFSET_WIDTH to 29)));

    -- Compute memory access index and offset
    mem_index <= to_integer(unsigned(mem_addr(TAG_WIDTH to TAG_WIDTH + INDEX_WIDTH - 1)));
    mem_offset <= to_integer(unsigned(mem_addr(30 - BLOCK_OFFSET_WIDTH to 31)));

    -- Determine if cache hit or miss
    A_hit <= '1' when instruction_cache(A_index).valid = '1' and instruction_cache(A_index).tag = A_addr(0 to TAG_WIDTH - 1) else '0';
    B_hit <= '1' when instruction_cache(B_index).valid = '1' and instruction_cache(B_index).tag = B_addr(0 to TAG_WIDTH - 1) else '0';

    -- Output cache data
    A_instruction <= instruction_cache(A_index).data(32 * A_offset to 32 * A_offset + 31);
    B_instruction <= instruction_cache(B_index).data(32 * B_offset to 32 * B_offset + 31);

    process(clk)
    begin
        if rising_edge(clk) then
            if read_mem_block then
                instruction_cache(mem_index).data(8 * mem_offset to 8 * mem_offset + 7) <= mem_data;
                if mem_offset = BLOCK_SIZE_BYTES - 1 then
                    read_mem_block <= '0';
                    instruction_cache(mem_index).valid <= '1';
                    instruction_cache(mem_index).tag <= mem_addr(0 to TAG_WIDTH - 1);
                else
                    mem_addr <= std_logic_vector(unsigned(mem_addr) + 1);
                end if;
            elsif not A_hit then
                read_mem_block <= '1';
                mem_addr <= A_addr(0 to TAG_WIDTH + INDEX_WIDTH - 1) & (30 - BLOCK_OFFSET_WIDTH to 31 => '0');
            elsif not B_hit then
                read_mem_block <= '1';
                mem_addr <= B_addr(0 to TAG_WIDTH + INDEX_WIDTH - 1) & (30 - BLOCK_OFFSET_WIDTH to 31 => '0');
            end if;
        end if;
    end process;

end architecture;