library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_generic is
    generic (
        WIDTH: positive := 32
    );
    Port (
        d : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
        ld : in STD_LOGIC; 
        clear : in STD_LOGIC; 
        clk : in STD_LOGIC; 
        q : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0) 
    );
end register_generic;

architecture Behavioral of register_generic is
begin
    process(clk, clear)
    begin
        if clear = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if ld = '1' then
                q <= d;
            end if;
        end if;
    end process;
end Behavioral;
