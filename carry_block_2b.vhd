library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_block_2b is
    Port ( x10 : in STD_LOGIC_VECTOR (1 downto 0);
         y10 : in STD_LOGIC_VECTOR (1 downto 0);
         C1 : in STD_LOGIC;
         C2 : out STD_LOGIC);
end carry_block_2b;

architecture Behavioral of carry_block_2b is
    signal g1, p1: std_logic;
begin
    g1 <= x10(1) and y10(1);
    p1 <= x10(1) or y10(1);
    C2 <= g1 or (p1 and C1);

end Behavioral;
