----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: firstname lastname and other guy/girl/...
-- 
-- Module Name: basic_register - Behavioral
-- Course Name: Lab Digital Design
-- 
-- Description: 
--  A "standard" n-bit register with asycnhronous reset and synchronous load,
--  using a "load enable" signal (le).
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity basic_register is
    generic(
        C_DATA_WIDTH : natural := 8
    );
    port(
                 clk : in  std_logic;  -- clock signal
               reset : in  std_logic;  -- async. reset
                  le : in  std_logic;  -- synch. load
             data_in : in  std_logic_vector(C_DATA_WIDTH-1 downto 0); -- n-bit data in
            data_out : out std_logic_vector(C_DATA_WIDTH-1 downto 0)  -- n-bit register output
    );
end basic_register;

architecture Behavioral of basic_register is
    -- TODO: (optionally) declare signals
    signal zero_sig : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
--    signal previous_data_out_sig : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
--    signal data_out_sig : std_logic_vector(C_DATA_WIDTH-1 downto 0);
 
    
    
begin
      
    -- TODO: write VHDL process
    process (clk, reset, le) begin
        if reset = '1' then
            data_out <= zero_sig;
        elsif rising_edge(clk) and le = '1' then
            data_out <= data_in;
        end if;

        
   end process;
--    
--        process (clk, reset, le, previous_data_out_sig, data_out_sig) begin
--        if reset = '1' then
--            data_out_sig <= zero_sig;
--        elsif rising_edge(clk) and le = '1' then
--            data_out_sig <= data_in;
--        elsif rising_edge(clk) and le = '0' then
--            data_out_sig <= previous_data_out_sig ;
--        end if;
--        
--        data_out <= data_out_sig;
--        previous_data_out_sig <= data_out_sig;
--       
--    end process;

end Behavioral;
