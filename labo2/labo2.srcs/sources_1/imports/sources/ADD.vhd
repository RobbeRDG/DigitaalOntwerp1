----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: Martijn Vanderschelden and Robbe De Groeve
-- 
-- Module Name: ADD - Structural
-- Course Name: Lab Digital Design
--
-- Description:
--  n-bit ripple carry adder
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ADD is
	generic(
       C_DATA_WIDTH : natural := 4
	);
	port(
                a : in  std_logic_vector((C_DATA_WIDTH-1) downto 0); -- input var 1
                b : in  std_logic_vector((C_DATA_WIDTH-1) downto 0); -- input var 2
         carry_in : in  std_logic;                                   -- input carry
           result : out std_logic_vector((C_DATA_WIDTH-1) downto 0); -- alu operation result
        carry_out : out std_logic                                    -- carry
	);
end entity;

architecture LDD1 of ADD is
	-- TODO: list of signals and components

	-- signals
	-- intermediate carry and sum signals
	signal carry_sig : std_logic_vector((C_DATA_WIDTH) downto 0);

	-- components
	-- initialize full bit adder
	component FA1B is
		port(
			--inputs
			i_A  : in std_logic;
			i_B  : in std_logic;
			i_carry : in std_logic;
			
			--outputs
			o_result   : out std_logic;
			o_carry : out std_logic
		);
	end component FA1B;

begin
	-- TODO: complete architecture description
	
	carry_sig(0) <= carry_in;
	generate_adders: for i in 0 to (C_DATA_WIDTH - 1) generate
		full_adders : FA1B
			port map (
				i_A => a(i), 
				i_B => b(i),
				i_carry => carry_sig(i),
				o_result => result(i),
				o_carry => carry_sig(i+1)
			);
	end generate generate_adders;
 
	carry_out <= carry_sig(C_DATA_WIDTH);



end LDD1;
