----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: Martijn Vanderschelden and Robbe De Groeve
-- 
-- Module Name: FA1B - Behavioral
-- Course Name: Lab Digital Design
--
-- Description:
--  Full adder (1-bit)
--
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY FA1B IS 
	PORT(
		-- TODO: complete entity declaration
		i_A  : in std_logic;
        i_B  : in std_logic;
        i_carry : in std_logic;
        
        --outputs
        o_result   : out std_logic;
        o_carry : out std_logic
	);
END entity;

ARCHITECTURE LDD1 OF FA1B IS 
BEGIN
	-- TODO: complete architecture
    o_result   <= i_A xor i_B xor i_carry;
    o_carry <= ((i_A xor i_B) and i_carry) or (i_A and i_B);
	
END LDD1;

