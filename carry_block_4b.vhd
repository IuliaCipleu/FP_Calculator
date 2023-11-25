library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_block_4b is
    Port ( x3210 : in STD_LOGIC_VECTOR (3 downto 0);
         y3210 : in STD_LOGIC_VECTOR (3 downto 0);
         C3 : in STD_LOGIC;
         C4 : out STD_LOGIC);
end carry_block_4b;

architecture Behavioral of carry_block_4b is

    signal g3, p3: std_logic;
begin
    g3 <= x3210(3) and y3210(3);
    p3 <= x3210(3) or y3210(3);
    C4 <= g3 or (p3 and C3);


end Behavioral;
