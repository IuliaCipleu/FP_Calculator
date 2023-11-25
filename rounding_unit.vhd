library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rounding_unit is
    Port (
        mantissa_in: in std_logic_vector(22 downto 0);
        round: in std_logic;
        mantissa_out: out std_logic_vector(22 downto 0)
    );
end rounding_unit;


architecture Behavioral of rounding_unit is
begin
    process (mantissa_in, round)
    begin
        if round = '1' and (mantissa_in(21 downto 1) /= "11111111111111111111110") then
            mantissa_out <= mantissa_in + 1;
        else
            mantissa_out <= mantissa_in;
        end if;
    end process;
end Behavioral;

