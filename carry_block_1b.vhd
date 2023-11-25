library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_block_1b is
    Port ( x0 : in STD_LOGIC;
         y0 : in STD_LOGIC;
         C0 : in STD_LOGIC;
         C1 : out STD_LOGIC);
end carry_block_1b;

architecture Behavioral of carry_block_1b is
    signal g0, p0: std_logic;
begin
    g0 <= x0 and y0;
    p0 <= x0 or y0;
    C1 <= g0 or (p0 and C0);

end Behavioral;
