library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TwosComplementToBinary is
    Port (
        twosComplementInput : in STD_LOGIC_VECTOR(47 downto 0);
        binaryOutput : out STD_LOGIC_VECTOR(47 downto 0)
    );
end TwosComplementToBinary;

architecture Behavioral of TwosComplementToBinary is
begin
    process(twosComplementInput)
    begin
        -- Convert 48-bit two's complement to binary
        if twosComplementInput(47) = '0' then
            -- Positive number, no modification needed
            binaryOutput <= twosComplementInput;
        else
            -- Negative number, perform two's complement conversion
            binaryOutput <= not twosComplementInput + "0000000000000001";
        end if;
    end process;
end Behavioral;
