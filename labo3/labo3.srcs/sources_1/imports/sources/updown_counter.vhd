----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: Martijn Vanderschelden & Robbe De Groeve 
-- 
-- Module Name: updown_counter - Behavioral
-- Course Name: Lab Digital Design
-- 
-- Description: 
--  n-bit up and down counter with asynchronous reset and overflow/underflow
--  indication. The count value is not further incremented/decremented when an
--  overflow/underflow occurs. 
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity updown_counter is
    generic(
        C_NR_BITS : integer := 4
    );
    port(
              clk : in  std_logic;
            reset : in  std_logic; -- async. reset
               up : in  std_logic; -- synch. count up
             down : in  std_logic; -- synch. count donw
        underflow : out std_logic; -- '1' on underflow
         overflow : out std_logic; -- '1' on overflow
            count : out std_logic_vector(C_NR_BITS-1 downto 0) -- count value
    );
end updown_counter;

architecture Behavioral of updown_counter is
begin    
--VHDL process
     process(clk, reset) is
        --zero vector
        variable zero_var : std_logic_vector(C_NR_BITS-1 downto 0) := (others=>'0');
        --max value
        variable max_var: std_logic_vector(C_NR_BITS-1 downto 0) := (others=>'1');
        --current count
        variable count_var : std_logic_vector(C_NR_BITS-1 downto 0) := (others=>'0');
        --overflow flag
        variable overflow_var: std_logic := '0';
        --underflow flag
        variable underflow_var: std_logic := '0';
        
        begin
        if reset = '1' then
            --When resetting, set everything to 0
            count_var := zero_var;
            overflow_var := '0';
            underflow_var := '0';
        elsif rising_edge(clk) then
            if up = '1' then
                if count_var = max_var then
                    --If the count has reached the maximum, keep current count 
                    --and set the overflow flag 
                    count_var := count_var;
                    overflow_var := '1';
                    underflow_var := '0';
                else
                    --raise count by 1 bit
                    count_var := count_var + '1';
                    overflow_var := '0';
                    underflow_var := '0';
                end if;           
            elsif down = '1' then
                if count_var = zero_var then
                    --If the count has reached the minimum, keep current count 
                    --and set the underflow flag 
                    count_var := count_var;
                    underflow_var := '1';
                    overflow_var := '0';
                else
                    --lower count by 1 bit
                    count_var := count_var - '1';
                    overflow_var := '0';
                    underflow_var := '0';
                end if;
            end if;
        end if;
        
     --After each run, connect the variables to the corresponding ports    
     count <= count_var;
     underflow <= underflow_var;
     overflow <= overflow_var;
            
     end process;
     


end Behavioral;
