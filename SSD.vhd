--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.all;

--entity SSD is
--    Port (
--        clk : in std_logic;
--        digit0 : in std_logic_vector (3 downto 0);
--        digit1 : in std_logic_vector (3 downto 0);
--        digit2 : in std_logic_vector (3 downto 0);
--        digit3 : in std_logic_vector (3 downto 0);
--        digit4 : in std_logic_vector (3 downto 0);
--        digit5 : in std_logic_vector (3 downto 0);
--        digit6 : in std_logic_vector (3 downto 0);
--        digit7 : in std_logic_vector (3 downto 0);
--        an : out std_logic_vector(3 downto 0);
--        cat : out std_logic_vector(6 downto 0)
--    );
--end SSD;

--architecture Behavioral of SSD is
--    signal counter_out: std_logic_vector(31 downto 0) := (others => '0');
--    signal O1: std_logic_vector(3 downto 0);
--    signal O2: std_logic_vector(3 downto 0) := "1110";
--    type digit_type is  array(0 to 7) of std_logic_vector(3 downto 0); 
--    signal digits : digit_type := (
--        "1110", "1101", "1011", "0111", -- Digits 0 to 3
--        "0000", "0000", "0000", "0000"  -- Digits 4 to 7 (placeholders)
--    );
--    signal led : std_logic_vector(6 downto 0);

--    constant FIRST_DIGIT_DURATION : natural := 3; -- in seconds
--    constant CLK_FREQUENCY : natural := 50E6; -- assuming a 50 MHz clock

--begin

--    process (clk)
--    begin
--        if rising_edge(clk) then
--            counter_out <= counter_out + 1;
--        end if;
--    end process;

--    process(counter_out, digit0, digit1, digit2, digit3, digit4, digit5, digit6, digit7)
--        variable display_digit : integer;
--    begin
--        -- Determine which digit to display based on the counter
--        if to_integer(unsigned(counter_out(31 downto 28))) < FIRST_DIGIT_DURATION * CLK_FREQUENCY then
--            display_digit := to_integer(unsigned(counter_out(3 downto 0)));
--            O1 <= digits(display_digit);
--        else
--            display_digit := to_integer(unsigned(counter_out(3 downto 0))) + 4;
--            O1 <= digits(display_digit);
--        end if;
--    end process;

--    with O1 SELECT
--        led <= "1111001" when "0001",   --1
--               "0100100" when "0010",   --2
--               "0110000" when "0011",   --3
--               "0011001" when "0100",   --4
--               "0010010" when "0101",   --5
--               "0000010" when "0110",   --6
--               "1111000" when "0111",   --7
--               "0000000" when "1000",   --8
--               "0010000" when "1001",   --9
--               "0001000" when "1010",   --A
--               "0000011" when "1011",   --b
--               "1000110" when "1100",   --C
--               "0100001" when "1101",   --d
--               "0000110" when "1110",   --E
--               "0001110" when "1111",   --F
--               "1000000" when others;   --0

--    process(counter_out, digits)
--        variable display_digit : integer;
--    begin
--        -- Determine which digit to display based on the counter
--        if to_integer(unsigned(counter_out(31 downto 28))) < FIRST_DIGIT_DURATION * CLK_FREQUENCY then
--            display_digit := to_integer(unsigned(counter_out(3 downto 0)));
--            O2 <= digits(display_digit);
--        else
--            display_digit := to_integer(unsigned(counter_out(3 downto 0))) + 4;
--            O2 <= digits(display_digit);
--        end if;
--    end process;

--    an <= O2;
--    cat <= led;

--end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity SSD is
    Port (
        clk : in std_logic;
        digit0 : in std_logic_vector (3 downto 0);
        digit1 : in std_logic_vector (3 downto 0);
        digit2 : in std_logic_vector (3 downto 0);
        digit3 : in std_logic_vector (3 downto 0);
        digit4 : in std_logic_vector (3 downto 0);
        digit5 : in std_logic_vector (3 downto 0);
        digit6 : in std_logic_vector (3 downto 0);
        digit7 : in std_logic_vector (3 downto 0);
        an : out std_logic_vector(3 downto 0);
        cat : out std_logic_vector(6 downto 0)
    );
end SSD;

architecture Behavioral of SSD is
    signal counter_out: std_logic_vector(31 downto 0) := (others => '0');
    signal O1: std_logic_vector(3 downto 0);
    signal O2: std_logic_vector(3 downto 0) := "1110";
    type digit_type is  array(0 to 7) of std_logic_vector(3 downto 0); 
    signal digits : digit_type := (
        "1110", "1101", "1011", "0111", -- Digits 0 to 3
        "0000", "0000", "0000", "0000"  -- Digits 4 to 7 (placeholders)
    );
    signal led : std_logic_vector(6 downto 0);

    constant FIRST_DIGIT_DURATION : natural := 3; -- in seconds
    constant CLK_FREQUENCY : natural := 50E6; -- assuming a 50 MHz clock

begin

    process (clk)
    begin
        if rising_edge(clk) then
            counter_out <= counter_out + 1;
        end if;
    end process;

    process(counter_out, digit0, digit1, digit2, digit3, digit4, digit5, digit6, digit7)
        variable display_digit : integer;
    begin
        -- Determine which digit to display based on the counter
        if to_integer(unsigned(counter_out(31 downto 28))) < FIRST_DIGIT_DURATION * CLK_FREQUENCY then
            display_digit := to_integer(unsigned(counter_out(3 downto 0)));
            O1 <= digits(display_digit);
        else
            display_digit := to_integer(unsigned(counter_out(3 downto 0))) + 4;
            O1 <= digits(display_digit);
        end if;
    end process;

    with O1 SELECT
        led <= "1111001" when "0001",   --1
               "0100100" when "0010",   --2
               "0110000" when "0011",   --3
               "0011001" when "0100",   --4
               "0010010" when "0101",   --5
               "0000010" when "0110",   --6
               "1111000" when "0111",   --7
               "0000000" when "1000",   --8
               "0010000" when "1001",   --9
               "0001000" when "1010",   --A
               "0000011" when "1011",   --b
               "1000110" when "1100",   --C
               "0100001" when "1101",   --d
               "0000110" when "1110",   --E
               "0001110" when "1111",   --F
               "1000000" when others;   --0

    process(counter_out, digits)
        variable display_digit : integer;
    begin
        -- Determine which digit to display based on the counter
        if to_integer(unsigned(counter_out(31 downto 28))) < FIRST_DIGIT_DURATION * CLK_FREQUENCY then
            display_digit := to_integer(unsigned(counter_out(3 downto 0)));
            O2 <= digits(display_digit);
        else
            display_digit := to_integer(unsigned(counter_out(3 downto 0))) + 4;
            O2 <= digits(display_digit);
        end if;
    end process;

    an <= O2;
    cat <= led;

end Behavioral;
