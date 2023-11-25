library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_lookahead_adder_23b is
    Port ( A: in std_logic_vector(22 downto 0);
         B: in std_logic_vector(22 downto 0);
         Cin: in std_logic;
         Sum: out std_logic_vector(22 downto 0);
         Cout: out std_logic
        );
end carry_lookahead_adder_23b;

architecture Behavioral of carry_lookahead_adder_23b is
    component carry_lookahead_adder is
        Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
             y : in STD_LOGIC_VECTOR (3 downto 0);
             cin : in STD_LOGIC;
             s : out STD_LOGIC_VECTOR (3 downto 0);
             cout : out STD_LOGIC);
    end component;

    signal C0, C1, C2, C3, C4, C5: std_logic;
    signal lastSum: std_logic_vector(3 downto 0);
begin

    adder_1: carry_lookahead_adder port map(A(3 downto 0), B(3 downto 0), Cin, Sum(3 downto 0), C0);
    adder_2: carry_lookahead_adder port map(A(7 downto 4), B(7 downto 4), C0, Sum(7 downto 4), C1);
    adder_3: carry_lookahead_adder port map(A(11 downto 8), B(11 downto 8), C1, Sum(11 downto 8), C2);
    adder_4: carry_lookahead_adder port map(A(15 downto 12), B(15 downto 12), C2, Sum(15 downto 12), C3);
    adder_5: carry_lookahead_adder port map(A(19 downto 16), B(19 downto 16), C3, Sum(19 downto 16), C4);
    adder_6: carry_lookahead_adder port map('0' & A(22 downto 20), '0'& B(22 downto 20), C4, lastSum, Cout);

    Sum(22 downto 20) <= lastSum (2 downto 0);

end Behavioral;
