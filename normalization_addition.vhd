library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all; 

entity normalization_addition is
    Port (
        mantissa_in: in std_logic_vector(22 downto 0);
        exponent_in: in std_logic_vector(7 downto 0);
        clk: in std_logic;
        mantissa_out: out std_logic_vector(22 downto 0);
        exponent_out: out std_logic_vector(7 downto 0)
    );
end normalization_addition;

architecture Behavioral of normalization_addition is
    signal shift_count: integer := 0;  -- Number of positions to shift the mantissa
    signal normalized_mantissa: std_logic_vector(22 downto 0);
    signal normalized_exponent: std_logic_vector(7 downto 0);
begin
    process (clk, mantissa_in, exponent_in)
    begin
        if rising_edge(clk) then
            -- Your normalization logic goes here
            -- Determine the number of positions to shift the mantissa
            -- Adjust the exponent accordingly

            -- Example: Shift the mantissa left until the most significant bit is '1'
            while mantissa_in(22) = '0' and shift_count < 23 and mantissa_in /= "0000000000000000000000" loop
                normalized_mantissa <= mantissa_in(21 downto 0) & '0';
                shift_count <= shift_count + 1;
                if mantissa_in(22) /= '0' or shift_count >= 23 or mantissa_in = "0000000000000000000000" then 
                    exit;
                end if;
            end loop;

            -- Adjust the exponent based on the number of shifts
            normalized_exponent <= std_logic_vector(unsigned(exponent_in) + shift_count);

            -- Output the normalized mantissa and exponent
            mantissa_out <= normalized_mantissa;
            exponent_out <= normalized_exponent;
        end if;
    end process;
end Behavioral;
