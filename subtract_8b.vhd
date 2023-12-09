library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all; 

entity subtract_8b is
    Port (
        A: in std_logic_vector(7 downto 0);
        B: in std_logic_vector(7 downto 0);
        Sub: out std_logic_vector(7 downto 0);
        Borrow: out std_logic
    );
end subtract_8b;

architecture Behavioral of subtract_8b is
    signal B_negated: std_logic_vector(7 downto 0);
    signal Sum: std_logic_vector(7 downto 0);
    signal Cout: std_logic;

    component carry_lookahead_adder_8b is
        Port (
            A: in std_logic_vector(7 downto 0);
            B: in std_logic_vector(7 downto 0);
            Cin: in std_logic;
            Sum: out std_logic_vector(7 downto 0);
            Cout: out std_logic
        );
    end component;
    
    component conv_2_complement is
    generic (
        WIDTH: positive := 8
    );
    Port (
        A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
        A_converted : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0)
    );
end component;

begin
    conversion: conv_2_complement generic map (
        WIDTH => 8
    )
        port map (B, B_negated);

    carry_lookahead_adder_8b_inst: carry_lookahead_adder_8b
        port map(
            A => A,
            B => B_negated,
            Cin => '0', 
            Sum => Sum,
            Cout => Cout
        );

    Sub <= Sum;
    Borrow <= '0' when A >= B else '1';

end Behavioral;
