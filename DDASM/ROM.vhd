
--  ____  ____      _    __  __  ____ ___
-- |  _ \|  _ \    / \  |  \/  |/ ___/ _ \
-- | | | | |_) |  / _ \ | |\/| | |  | | | |
-- | |_| |  _ <  / ___ \| |  | | |__| |_| |
-- |____/|_| \_\/_/   \_\_|  |_|\____\___/
--                           research group
--                             dramco.be/
--
--  KU Leuven - Technology Campus Gent,
--  Gebroeders De Smetstraat 1,
--  B-9000 Gent, Belgium
--
--         File: ROM.vhd
--      Created: 08:59:14 07-12-2020
--       Author: Martijn Vanderschelden and Robbe De Groeve
--
--  Description: LDD Processor Program ROM



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ROM is
    generic( -- do not change these values
        C_ADDR_WIDTH : natural := 7;
        C_DATA_WIDTH : natural := 8
    );
    port(
                 clk : in  std_logic;
             read_en : in  std_logic;
         address_bus : in  std_logic_vector((C_ADDR_WIDTH -1) downto 0);
        data_bus_out : out std_logic_vector((C_DATA_WIDTH -1) downto 0)
    );
end entity;

architecture LDOI of ROM is

	-- Build a 2-D array type for the ROM
	subtype word_t is std_logic_vector((C_DATA_WIDTH-1) downto 0);
	type memory_t is array(2**C_ADDR_WIDTH-1 downto 0) of word_t;

	-- Initialize all memory locations with the desired data
	signal rom : memory_t := (
		-- program start (do not alter!)
		  0 => "00100000", -- jmp setup
		  1 => "00000010",
		  2 => "01000000", -- movl count, 00
		  3 => "00000000",
		  4 => "01000001", -- movl prev, 00
		  5 => "00000000",
		  6 => "00100000", -- jmp loop
		  7 => "00001000",
		  8 => "00011000", -- call update_led
		  9 => "00111110",
		 10 => "00011000", -- call check_buttons
		 11 => "00001110",
		 12 => "00100000", -- jmp loop
		 13 => "00001000",
		 14 => "01010010", -- ldr  r2, e8
		 15 => "11101000",
		 16 => "01001011", -- movr r3, r2
		 17 => "01000000",
		 18 => "11001011", -- xorr r3, prev
		 19 => "00100000",
		 20 => "10101011", -- andr r3, r2
		 21 => "01000000",
		 22 => "01001001", -- movr prev, r2
		 23 => "01000000",
		 24 => "11110011", -- cmpl r3, 01
		 25 => "00000001",
		 26 => "00101010", -- je min_count_check
		 27 => "00110100",
		 28 => "11110011", -- cmpl r3, 02
		 29 => "00000010",
		 30 => "00101010", -- je reset_count
		 31 => "00110000",
		 32 => "11110011", -- cmpl r3, 04
		 33 => "00000100",
		 34 => "00101010", -- je max_count_check
		 35 => "00100110",
		 36 => "00010000", -- retc
		 37 => "00000000",
		 38 => "11110000", -- cmpl count, fe
		 39 => "11111110",
		 40 => "00101100", -- js count_up
		 41 => "00101100",
		 42 => "00010000", -- retc
		 43 => "00000000",
		 44 => "11010000", -- addl count, 01
		 45 => "00000001",
		 46 => "00010000", -- retc
		 47 => "00000000",
		 48 => "01000000", -- clr count
		 49 => "00000000",
		 50 => "00010000", -- retc
		 51 => "00000000",
		 52 => "11110000", -- cmpl count, 00
		 53 => "00000000",
		 54 => "00101011", -- jg count_down
		 55 => "00111010",
		 56 => "00010000", -- retc
		 57 => "00000000",
		 58 => "11100000", -- subl count, 01
		 59 => "00000001",
		 60 => "00010000", -- retc
		 61 => "00000000",
		 62 => "01011000", -- str f0, count
		 63 => "11110000",
		 64 => "00010000", -- retc
		 65 => "00000000",
		 66 => "00000000",
		 67 => "00000000",
		 68 => "00000000",
		 69 => "00000000",
		 70 => "00000000",
		 71 => "00000000",
		 72 => "00000000",
		 73 => "00000000",
		 74 => "00000000",
		 75 => "00000000",
		 76 => "00000000",
		 77 => "00000000",
		 78 => "00000000",
		 79 => "00000000",
		 80 => "00000000",
		 81 => "00000000",
		 82 => "00000000",
		 83 => "00000000",
		 84 => "00000000",
		 85 => "00000000",
		 86 => "00000000",
		 87 => "00000000",
		 88 => "00000000",
		 89 => "00000000",
		 90 => "00000000",
		 91 => "00000000",
		 92 => "00000000",
		 93 => "00000000",
		 94 => "00000000",
		 95 => "00000000",
		 96 => "00000000",
		 97 => "00000000",
		 98 => "00000000",
		 99 => "00000000",
		100 => "00000000",
		101 => "00000000",
		102 => "00000000",
		103 => "00000000",
		104 => "00000000",
		105 => "00000000",
		106 => "00000000",
		107 => "00000000",
		108 => "00000000",
		109 => "00000000",
		110 => "00000000",
		111 => "00000000",
		112 => "00000000",
		113 => "00000000",
		114 => "00000000",
		115 => "00000000",
		116 => "00000000",
		117 => "00000000",
		118 => "00000000",
		119 => "00000000",
		120 => "00000000",
		121 => "00000000",
		122 => "00000000",
		123 => "00000000",
		124 => "00000000",
		125 => "00000000",
		126 => "00000000",
		127 => "00000000"
		-- program end (do not alter!)
	);

	signal rdata : std_logic_vector((C_DATA_WIDTH-1) downto 0);
begin
	-- the one and only process: output the data stored at the address (addr)
	rdata <= rom(conv_integer(address_bus));
	
	DO_REG_PROC : process(clk)
	   variable do_reg : std_logic_vector((C_DATA_WIDTH-1) downto 0) := (others=>'0');
	begin
        if(rising_edge(clk)) then
            if read_en = '1' then
                do_reg := rdata;
            end if;
        end if;
        data_bus_out <= do_reg;
	end process DO_REG_PROC;

end LDOI;


