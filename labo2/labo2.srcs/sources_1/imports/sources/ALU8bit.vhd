----------------------------------------------------------------------------------
-- Institution: KU Leuven
-- Students: Martijn Vanderschelden and Robbe De Groeve
-- 
-- Module Name: ALU8bit - Behavioral
-- Course Name: Lab Digital Design
--
-- Description: 
--  8-bit ALU that supports several logic and arithmetic operations
--
----------------------------------------------------------------------------------


library IEEE;
library processor_pkg;
use IEEE.STD_LOGIC_1164.ALL;
use work.processor_pkg.ALL;

entity ALU8bit is
    generic(
        C_DATA_WIDTH : natural := 8
    );
    port(
         X : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
         Y : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
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
end ALU8bit;

architecture Behavioral of ALU8bit is
    -- operations defined in processor_pkg
    -- ALU_OP_NOT  
    -- ALU_OP_AND  
    -- ALU_OP_OR   
    -- ALU_OP_XOR  
    -- ALU_OP_ADD  
    -- ALU_OP_CMP  
    -- ALU_OP_RR   
    -- ALU_OP_RL   
    -- ALU_OP_SWAP 

    -- operation results
    signal result_i      : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal not_result_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal and_result_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal or_result_i   : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal xor_result_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal rr_result_i   : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal rl_result_i   : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal add_result_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal swap_result_i : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    -- help signals
    signal add_secondary_input_i     : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');
    signal add_carry_in_i: std_logic := '0';
    signal add_carry_i   : std_logic := '0';
    signal zero_sig     : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others=>'0');

    
    -- we use a separate module for the addition/subtraction
    component ADD is
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
    end component;
begin
    -- implementation of some operations
    -- and
    and_result_i <=  X and Y ;
    -- or
    or_result_i <=  X or Y ;
    -- xor
    xor_result_i <=  X xor Y ;
    -- not
    not_result_i <=   not X ;
    -- rr
    rr_result_i <=   '0' & X((C_DATA_WIDTH-1) downto 1);
    -- rl
    rl_result_i <=  X((C_DATA_WIDTH-2) downto 0) & '0';
    -- swap
    swap_result_i <= X(3 downto 0) & X((C_DATA_WIDTH-1) downto 4); 
    
    -- Ripple carry adder instantiation
    ADDER : ADD
    generic map(
        C_DATA_WIDTH => C_DATA_WIDTH -- this will change the default width of the adder to the width specified here
    )
    port map(
                a => X,
                b => add_secondary_input_i,
         carry_in => add_carry_in_i,
           result => add_result_i,
        carry_out => add_carry_i
    );

    -- addition and subtraction
    -- met when else
    add_secondary_input_i <= not Y when op = ALU_OP_SUB else Y ;
    add_carry_in_i <= '1' when op = ALU_OP_SUB else '0' ;
    
    -- set 'result_i' to a specific operation result based on the selected operation 'op'
    -- result mux:
    with op select result_i <=
        not_result_i when ALU_OP_NOT,
        and_result_i when ALU_OP_AND,
        or_result_i when ALU_OP_OR,
        xor_result_i when ALU_OP_XOR,
        add_result_i when ALU_OP_ADD,
        add_result_i when ALU_OP_SUB,
        rr_result_i when ALU_OP_RR,
        rl_result_i when ALU_OP_RL,
        swap_result_i when ALU_OP_SWAP,
        zero_sig when others;
    
    -- point the chosen result_i to the output
    Z <= result_i;                  
    
    -- control the flags
    -- carry flag: 1 carry flag for SUB, ADD, RR and RL (based on op)
    with op select cf <= 
        add_carry_i when ALU_OP_ADD,            -- take the output carry from the ADD component
        not add_carry_i when ALU_OP_SUB,        -- take the inverse of the output carry from the ADD component
        X(0) when ALU_OP_RR,                    -- when RR, place least significant bit in carry
        X(C_DATA_WIDTH-1) when ALU_OP_RL,       -- when RL, place most significant bit in carry
        '0' when others;                        -- default case
     

    -- zero flag
    zf <= '1' when result_i = zero_sig else '0'; -- set to zero when result_i is vector of zeros
    
    -- equal, smaller, greater flag
    -- compare the two input signals
    ef <= '1' when X = Y else '0' ;
    gf <= '1' when X > Y else '0' ;
    sf <= '1' when X < Y else '0';

end Behavioral;
