library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MantissaNormalizationUnit is
    Port (
        mantissa_product: in STD_LOGIC_VECTOR(47 downto 0);
        exponent_product: in STD_LOGIC_VECTOR(7 downto 0);
        clk: in std_logic;
        mantissa_normalized: out STD_LOGIC_VECTOR(22 downto 0);
        exponent_normalized: out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity MantissaNormalizationUnit;

architecture Behavioral of MantissaNormalizationUnit is
    signal mantissa_shifted : STD_LOGIC_VECTOR(47 downto 0);
    signal exponent_shifted : STD_LOGIC_VECTOR(7 downto 0);
    signal nonZero : STD_LOGIC := '0';

begin
    nonZero <= '1' when mantissa_product /= "00000000000000000000000" else '0';
    process(clk, mantissa_product)
    begin
        if rising_edge(clk) then
            if mantissa_product(46) = '1' then
                -- Mantissa is negative, shift right
                mantissa_shifted <= '0' & mantissa_product(46 downto 0);
                exponent_shifted <= std_logic_vector(unsigned(exponent_product) + 1);
            else
                -- Mantissa is positive, shift left
                mantissa_shifted <=  mantissa_product(47 downto 1)& '0';
                exponent_shifted <= std_logic_vector(unsigned(exponent_product) - 1);
            end if;
        end if;
    end process;

    -- Choose the larger of the two exponents after shifting
    process (clk, mantissa_shifted, exponent_shifted)
    begin
        if rising_edge(clk) then
            mantissa_normalized <= mantissa_shifted(22 downto 0);
            exponent_normalized <= exponent_shifted;
        end if;
    end process;

end Behavioral;
