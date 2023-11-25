library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity subtract_8b_tb is
    --  Port ( );
end subtract_8b_tb;

architecture Behavioral of subtract_8b_tb is
    component subtract_8b is
        Port (
            A: in std_logic_vector(7 downto 0);
            B: in std_logic_vector(7 downto 0);
            Sub: out std_logic_vector(7 downto 0);
            Borrow: out std_logic
        );
    end component;
    
    signal A, B, Sub: std_logic_vector(7 downto 0);
    signal Borrow: std_logic;
begin

    A <= "00001000", "00000010" after 10 ns, "10101010" after 20 ns;
    B <= "00000100", "00000110" after 10 ns, "01111111" after 20 ns;
    
    DUT: subtract_8b port map(A, B, Sub, Borrow);

end Behavioral;
