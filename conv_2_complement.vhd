library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity conv_2_complement is
    generic (
        WIDTH: positive := 8
    );
    Port (
        A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
        A_converted : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0)
    );
end conv_2_complement;

architecture Behavioral of conv_2_complement is
    signal A_negated : std_logic_vector(WIDTH - 1 downto 0);
begin
    A_negated <= not A;
    A_converted <= A_negated + "1";

end Behavioral;
