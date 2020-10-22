----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: firstname lastname and other guy/girl/...
-- 
-- Module Name: program_counter - Behavioral
-- Course Name: Lab Digital Design
-- 
-- Description: 
--  An n-bit program counter module. The count step is set during instantiation.
--  A new count value can be loaded synchronously (le). Reset is asynchronous.
--  For a synchronous reset -> load "00..0"
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter is
    generic(
        C_PC_WIDTH : natural := 8;
         C_PC_STEP : natural := 2
    );
    port(
               clk : in  std_logic;
             reset : in  std_logic; -- async. reset
                up : in  std_logic; -- synch. count up
                le : in  std_logic; -- synch. load enable
             pc_in : in  std_logic_vector(C_PC_WIDTH-1 downto 0); -- parallel data in
            pc_out : out std_logic_vector(C_PC_WIDTH-1 downto 0)  -- parallel data out
    );
end program_counter;

architecture Behavioral of program_counter is
    -- TODO: (optionally) declare signals

begin

    -- TODO: write VHDL process
    process(clk, reset) is
        variable pc_out_var: std_logic_vector((C_PC_WIDTH-1) downto 0) := (others=>'0');
        variable zero_var : std_logic_vector(C_PC_WIDTH-1 downto 0) := (others=>'0');
        variable step_size : std_logic_vector(C_PC_WIDTH-1 downto 0) := (others=>'0');


    begin
        step_size := std_logic_vector(TO_UNSIGNED(C_PC_STEP, step_size'length));

        if reset = '1' then
            pc_out_var := zero_var;
        elsif rising_edge(clk) then
           if  up = '1' then
            pc_out_var := pc_out_var + step_size;
           else
            if le = '1' then
                pc_out_var := pc_in;
            end if;
           end if;
        end if;
        
    pc_out <= pc_out_var;
            
    end process;
    
                            
end Behavioral;
