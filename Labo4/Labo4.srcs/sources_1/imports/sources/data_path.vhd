----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: Martijn Vanderschelden and Robbe De Groeve
-- 
-- Module Name: data_path - Behavioral
-- Course Name: Lab Digital Design
-- 
-- Description: 
--  A preliminary Data Path for the processor.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library work;
use work.processor_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_path is
    generic(
        C_DATA_WIDTH : natural := 8;
          C_NR_FLAGS : natural := 5
    );
    port(
                 clk : in  std_logic;
               reset : in  std_logic;
         -- ALU-related control inputs 
              alu_op : in  std_logic_vector(3 downto 0);
                y_le : in  std_logic;
                z_le : in  std_logic;
            flags_le : in  std_logic;
         -- Regsiter File control inputs
         reg_file_le : in  std_logic;
             Rsource : in  std_logic_vector(2 downto 0);
        Rdestination : in  std_logic_vector(2 downto 0);
         -- CPU bus control and inputs
         cpu_bus_sel : in  std_logic_vector(3 downto 0);
                dibr : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
                  pc : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
                  sp : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
                ir_l : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
         -- Data path outputs
             cpu_bus : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
               flags : out std_logic_vector(C_NR_FLAGS-1 downto 0)
          
    );
end data_path;

architecture Behavioral of data_path is
    -- Constants
    constant C_NR_REGS : natural := 8;
    constant C_ZF : natural := 4;
    constant C_CF : natural := 3;
    constant C_EF : natural := 2;
    constant C_GF : natural := 1;
    constant C_SF : natural := 0;
    constant IV : std_logic_vector(C_DATA_WIDTH-1 downto 0) := std_logic_vector( RESIZE(to_unsigned(2,3), C_DATA_WIDTH));

    -- Signals ------------------------------------------------------------------------------------------------------
    -- Data lines
    signal cpu_bus_i : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal y_i : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal z_i : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal alu_out_i : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal alu_flags_i : std_logic_vector(C_NR_FLAGS-1 downto 0) := (others=>'0');
    signal flags_i : std_logic_vector(C_NR_FLAGS-1 downto 0) := (others=>'0');
    signal reg_file_out_i : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal reg_file_in_sel_i : std_logic_vector(C_NR_REGS-1 downto 0) := (others=>'0');
    signal reg_file_out_sel_i : std_logic_vector(C_NR_REGS-1 downto 0) := (others=>'0');
    -- Control lines
    signal y_le_i : std_logic := '0';
    signal z_le_i : std_logic := '0';
    signal reg_file_le_i : std_logic := '0';
    signal flags_le_i : std_logic := '0';
    signal alu_op_i : std_logic_vector(3 downto 0) := (others=>'0');
    signal Rs_i : std_logic_vector(2 downto 0) := (others=>'0');
    signal Rd_i : std_logic_vector(2 downto 0) := (others=>'0');

    -- Components ---------------------------------------------------------------------------------------------------
    -- Register file
    component register_file is
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
    end component;

    -- Basic 8-bit register
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
    
    -- Arithmetic and Logic Unit
    component ALU8bit is
    generic(
        C_DATA_WIDTH : natural := 8
    );
    port(
         X : in std_logic_vector(C_DATA_WIDTH-1 downto 0);
         Y : in std_logic_vector(C_DATA_WIDTH-1 downto 0);
         Z : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
        -- operation select
        op : in std_logic_vector(3 downto 0);
        -- flags
        zf : out std_logic;
        cf : out std_logic;
        ef : out std_logic;
        gf : out std_logic;
        sf : out std_logic
    );
    end component;

begin
    -- Outputs mapped to signals
    cpu_bus <= cpu_bus_i;
    flags <= flags_i;
    
    
    -- CPU bus control multiplexer
    cpu_bus_i <= dibr when cpu_bus_sel = SFR_DBR else
                 z_i when cpu_bus_sel = SFR_Z else
                 pc when cpu_bus_sel = SFR_PC else
                 IV when cpu_bus_sel = SFR_IV else
                 reg_file_out_i when cpu_bus_sel = GP_REG else
                 sp when cpu_bus_sel = SFR_SP else
                 ir_l when cpu_bus_sel = SFR_IR_L;
    
    -- ALU secondary input (Y register)
    B_REGX : basic_register
    generic map (
        C_DATA_WIDTH => C_DATA_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        le => y_le,
        data_in => cpu_bus_i,
        data_out => y_i
    );

    
    -- ALU output (Z register)
    B_REGZ : basic_register
    generic map (
        C_DATA_WIDTH => C_DATA_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        le => z_le,
        data_in => alu_out_i,
        data_out => z_i
    );    

    
    -- ALU flags register
    B_REGY : basic_register
    generic map (
        C_DATA_WIDTH => C_NR_FLAGS  --in-/output data is the flag vector
    )
    port map(
        clk => clk,
        reset => reset,
        le => flags_le,
        data_in => alu_flags_i,
        data_out => flags_i
    );
    
    -- ALU
    ALU : ALU8bit
    generic map (
        C_DATA_WIDTH => C_DATA_WIDTH
    )
    port map(
         X => cpu_bus_i,
         Y => y_i,
         Z => alu_out_i,
        op => alu_op,
        
        -- all flag indexes are defined in processor_pkg
        zf => alu_flags_i(C_ZF),
        cf => alu_flags_i(C_CF),
        ef => alu_flags_i(C_EF),
        gf => alu_flags_i(C_GF),
        sf => alu_flags_i(C_SF)
    );
    
    
    
    -- register file register selection decoding using processor_pkg definitions
    reg_file_in_sel_i <= "00000001" when Rdestination = REGFILE_R0 else
                         "00000010" when Rdestination = REGFILE_R1 else
                         "00000100" when Rdestination = REGFILE_R2 else
                         "00001000" when Rdestination = REGFILE_R3 else
                         "00010000" when Rdestination = REGFILE_R4 else
                         "00100000" when Rdestination = REGFILE_R5 else
                         "01000000" when Rdestination = REGFILE_R6 else
                         "10000000" when Rdestination = REGFILE_R7; 
                         
    reg_file_out_sel_i <= "00000001" when Rsource = REGFILE_R0 else
                          "00000010" when Rsource = REGFILE_R1 else
                          "00000100" when Rsource = REGFILE_R2 else
                          "00001000" when Rsource = REGFILE_R3 else
                          "00010000" when Rsource = REGFILE_R4 else
                          "00100000" when Rsource = REGFILE_R5 else
                          "01000000" when Rsource = REGFILE_R6 else
                          "10000000" when Rsource = REGFILE_R7;                      
                         
    

    -- register file
    REG : register_file
    generic map (
        C_DATA_WIDTH => C_DATA_WIDTH,
        C_NR_REGS => C_NR_REGS
    )
    port map(
        clk => clk,
        reset => reset,
        le => reg_file_le,
        in_sel => reg_file_in_sel_i,
        out_sel => reg_file_out_sel_i,
        data_in => cpu_bus_i,
        data_out => reg_file_out_i
    );

    
end Behavioral;
