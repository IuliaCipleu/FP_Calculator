library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GenericShifter is
    generic (
        DATA_WIDTH   : integer := 8;     -- Width of the data to be shifted
        SHIFT_AMOUNT : integer := 1;     -- Number of positions to shift
        LEFT_SHIFT   : boolean := true   -- Direction of shifting (true for left, false for right)
    );
    Port (
        data_in   : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        data_out  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end entity GenericShifter;

architecture Behavioral of GenericShifter is
    signal temp_data : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal zeros : STD_LOGIC_VECTOR(SHIFT_AMOUNT - 1 downto 0) := (others => '0');

begin
    process(data_in)
    begin
        if LEFT_SHIFT then
            temp_data <= data_in(SHIFT_AMOUNT - 1 downto 0) & zeros;
        else
            temp_data <= zeros & data_in(DATA_WIDTH - 1 downto SHIFT_AMOUNT);
        end if;
    end process;

    data_out <= temp_data;
end architecture Behavioral;
