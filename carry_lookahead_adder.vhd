library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_lookahead_adder is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
         y : in STD_LOGIC_VECTOR (3 downto 0);
         cin : in STD_LOGIC;
         s : out STD_LOGIC_VECTOR (3 downto 0);
         cout : out STD_LOGIC);
end carry_lookahead_adder;

architecture Behavioral of carry_lookahead_adder is

    component full_adder is
        Port ( A : in STD_LOGIC;
             B : in STD_LOGIC;
             Cin : in STD_LOGIC;
             S : out STD_LOGIC;
             Cout : out STD_LOGIC);
    end component;

    component carry_block_1b is
        Port ( x0 : in STD_LOGIC;
             y0 : in STD_LOGIC;
             C0 : in STD_LOGIC;
             C1 : out STD_LOGIC);
    end component;

    component carry_block_2b is
    Port ( x10 : in STD_LOGIC_VECTOR (1 downto 0);
         y10 : in STD_LOGIC_VECTOR (1 downto 0);
         C1 : in STD_LOGIC;
         C2 : out STD_LOGIC);
end component;

    component carry_block_3b is
    Port ( x210 : in STD_LOGIC_VECTOR (2 downto 0);
         y210 : in STD_LOGIC_VECTOR (2 downto 0);
         C2 : in STD_LOGIC;
         C3 : out STD_LOGIC);
end component;

    component carry_block_4b is
    Port ( x3210 : in STD_LOGIC_VECTOR (3 downto 0);
         y3210 : in STD_LOGIC_VECTOR (3 downto 0);
         C3 : in STD_LOGIC;
         C4 : out STD_LOGIC);
end component;

    signal C1, C2, C3: std_logic;
    signal cout0, cout1, cout2, cout3: std_logic;

begin

    full_adder_inst1: full_adder port map (x(0), y(0), cin, s(0), cout0);
    carry_1: carry_block_1b port map (x(0), y(0), cin, C1);
    full_adder_inst2: full_adder port map (x(1), y(1), C1, S(1), cout1);
    carry_2: carry_block_2b port map (x(1 downto 0), y(1 downto 0), C1, C2);
    full_adder_inst3: full_adder port map (x(2), y(2), C2, S(2), cout2);
    carry_3: carry_block_3b port map (x(2 downto 0), y(2 downto 0), C2, C3);
    full_adder_inst4: full_adder port map (x(3), y(3), C3, S(3), cout3);
    carry_4: carry_block_4b port map (x, y, C3, cout);

end Behavioral;
