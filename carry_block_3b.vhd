library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_block_3b is
    Port ( x210 : in STD_LOGIC_VECTOR (2 downto 0);
         y210 : in STD_LOGIC_VECTOR (2 downto 0);
         C2 : in STD_LOGIC;
         C3 : out STD_LOGIC);
end carry_block_3b;

architecture Behavioral of carry_block_3b is

    signal g2, p2: std_logic;
begin
    g2 <= x210(2) and y210(2);
    p2 <= x210(2) or y210(2);
    C3 <= g2 or (p2 and C2);

end Behavioral;
