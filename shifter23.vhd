library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter_generic is
    generic (
        WIDTH : positive := 23
    );
    Port (
        A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
        DIR : in STD_LOGIC;
        RESULT : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0)
    );
end shifter_generic;

architecture Behavioral of shifter_generic is
begin
    process(DIR)
    begin
        if DIR = '0' then
            RESULT <= A(WIDTH - 2 downto 0) & '0'; -- Shift left (Logical shift left) by 1 bit
        else
            RESULT <= '0' & A(WIDTH - 2 downto 1); -- Shift right (Logical shift right) by 1 bit
        end if;
    end process;
end Behavioral;
