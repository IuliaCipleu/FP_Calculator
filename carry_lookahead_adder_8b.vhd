library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_lookahead_adder_8b is
    Port ( A: in std_logic_vector(7 downto 0);
         B: in std_logic_vector(7 downto 0);
         Cin: in std_logic;
         Sum: out std_logic_vector(7 downto 0);
         Cout: out std_logic
        );
end carry_lookahead_adder_8b;

architecture Behavioral of carry_lookahead_adder_8b is
    component carry_lookahead_adder is
        Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
             y : in STD_LOGIC_VECTOR (3 downto 0);
             cin : in STD_LOGIC;
             s : out STD_LOGIC_VECTOR (3 downto 0);
             cout : out STD_LOGIC);
    end component;

    signal C0: std_logic;

begin

    adder_1: carry_lookahead_adder port map(A(3 downto 0), B(3 downto 0), Cin, Sum(3 downto 0), C0);
    adder_2: carry_lookahead_adder port map(A(7 downto 4), B(7 downto 4), C0, Sum(7 downto 4), Cout);

end Behavioral;
