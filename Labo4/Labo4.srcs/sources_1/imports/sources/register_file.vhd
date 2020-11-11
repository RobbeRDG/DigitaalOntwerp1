----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: firstname lastname and other guy/girl/...
-- 
-- Module Name: register_file - Behavioral
-- Course Name: Lab Digital Design
--
-- Description:
--  Generic register file description. The number of registers and the data width
--  can be set with C_NR_REGS and C_DATA_WIDTH respectively.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_file is
    generic(
        C_DATA_WIDTH : natural := 8;
           C_NR_REGS : natural := 8
    );
    port(
                 clk : in  std_logic;
               reset : in  std_logic;
                  le : in  std_logic;
              in_sel : in  std_logic_vector(C_NR_REGS-1 downto 0);
             out_sel : in  std_logic_vector(C_NR_REGS-1 downto 0);
             data_in : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
            data_out : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
    -- TODO: declare what will be used
    --new data type consiting of a vector of vectors
    type register_bus is array (C_NR_REGS-1 downto 0) of std_logic_vector(C_DATA_WIDTH-1 downto 0);

    -- signals
    signal selection_i : std_logic_vector((C_NR_REGS-1) downto 0); 
    signal le_vector_i: std_logic_vector((C_NR_REGS-1) downto 0);
    signal zero_vector_i: std_logic_vector((C_DATA_WIDTH-1) downto 0) := (others => '0');
    signal register_input_i : register_bus;
    signal register_output_i : register_bus;
    signal register_output_selection_i : register_bus;
    signal register_or_i : register_bus;
    

    -- components
    component basic_register is
    generic(
        C_DATA_WIDTH : natural := 8
    );
    port(
                 clk : in  std_logic;
               reset : in  std_logic;
                  le : in  std_logic;
             data_in : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
            data_out : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
    );
    end component;
    
    
    
begin
    -- TODO: describe how it's all connected and how it behaves
    
    --generate the selection_i signal
    le_vector_i <= (others => '0') when le = '0' else
                   (others => '1') when le = '1';
    selection_i <= le_vector_i and in_sel;
    
    
    --Generate the registers with the corresponding input values
    GEN_REG: 
    for I in 0 to (C_NR_REGS-1) generate                     
      REGX : basic_register 
        port map(
            clk => clk,
            reset => reset,
            data_in => data_in,
            le => selection_i(I),
            data_out => register_output_i(I)
        );
      
      --Output multiplexer  
      register_output_selection_i(I) <= register_output_i(I) when out_sel(I) = '1' else
                                        zero_vector_i when out_sel(I) = '0';
   end generate GEN_REG;
   
   
   --generate the logic for the register outputs
   register_or_i(C_NR_REGS-2) <=  register_output_selection_i(C_NR_REGS-2) or register_output_selection_i(C_NR_REGS-1);
   GEN_OUT:
   for I in (C_NR_REGS-3) downto 0 generate
      register_or_i(I) <= register_output_selection_i(I) or register_or_i(I+1);
   end generate GEN_OUT;
            
data_out <= register_or_i(0);
  
end Behavioral;

