library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all; 

entity subtract_23b is
    Port (
        A: in std_logic_vector(22 downto 0);
        B: in std_logic_vector(22 downto 0);
        Sub: out std_logic_vector(22 downto 0);
        Borrow: out std_logic
    );
end subtract_23b;

architecture Behavioral of subtract_23b is
    signal B_negated: std_logic_vector(22 downto 0);
    signal Sum: std_logic_vector(22 downto 0);
    signal Cout: std_logic;

    component carry_lookahead_adder_23b is
        Port (
            A: in std_logic_vector(22 downto 0);
            B: in std_logic_vector(22 downto 0);
            Cin: in std_logic;
            Sum: out std_logic_vector(22 downto 0);
            Cout: out std_logic
        );
    end component;
    
    component conv_2_complement is
    generic (
        WIDTH: positive := 23
    );
    Port (
        A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
        A_converted : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0)
    );
end component;

begin
    conversion: conv_2_complement generic map (
        WIDTH => 23
    )
        port map (B, B_negated);

    carry_lookahead_adder_23b_inst: carry_lookahead_adder_23b
        port map(
            A => A,
            B => B_negated,
            Cin => '0', 
            Sum => Sum,
            Cout => Cout
        );

    Sub <= Sum;
    Borrow <= Cout;

end Behavioral;