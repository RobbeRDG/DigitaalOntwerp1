
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
--         File: 
--      Created: 
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
		  0 => "00000000",
		  1 => "00000000",
		  2 => "00000000",
		  3 => "00000000",
		  4 => "00000000",
		  5 => "00000000",
		  6 => "00000000",
		  7 => "00000000",
		  8 => "00000000",
		  9 => "00000000",
		 10 => "00000000",
		 11 => "00000000",
		 12 => "00000000",
		 13 => "00000000",
		 14 => "00000000",
		 15 => "00000000",
		 16 => "00000000",
		 17 => "00000000",
		 18 => "00000000",
		 19 => "00000000",
		 20 => "00000000",
		 21 => "00000000",
		 22 => "00000000",
		 23 => "00000000",
		 24 => "00000000",
		 25 => "00000000",
		 26 => "00000000",
		 27 => "00000000",
		 28 => "00000000",
		 29 => "00000000",
		 30 => "00000000",
		 31 => "00000000",
		 32 => "00000000",
		 33 => "00000000",
		 34 => "00000000",
		 35 => "00000000",
		 36 => "00000000",
		 37 => "00000000",
		 38 => "00000000",
		 39 => "00000000",
		 40 => "00000000",
		 41 => "00000000",
		 42 => "00000000",
		 43 => "00000000",
		 44 => "00000000",
		 45 => "00000000",
		 46 => "00000000",
		 47 => "00000000",
		 48 => "00000000",
		 49 => "00000000",
		 50 => "00000000",
		 51 => "00000000",
		 52 => "00000000",
		 53 => "00000000",
		 54 => "00000000",
		 55 => "00000000",
		 56 => "00000000",
		 57 => "00000000",
		 58 => "00000000",
		 59 => "00000000",
		 60 => "00000000",
		 61 => "00000000",
		 62 => "00000000",
		 63 => "00000000",
		 64 => "00000000", 
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


