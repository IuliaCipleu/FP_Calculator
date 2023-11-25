library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD2 is
    Port (clk : in std_logic;
         digit0 : in std_logic_vector (3 downto 0);
         digit1 : in std_logic_vector (3 downto 0);
         digit2 : in std_logic_vector (3 downto 0);
         digit3 : in std_logic_vector (3 downto 0);
         an : out std_logic_vector(3 downto 0);
         cat : out std_logic_vector(6 downto 0) );
end SSD2;

architecture Behavioral of SSD2 is
    signal counter_out: std_logic_vector(15 downto 0):= (others=>'0');
    signal O1: std_logic_vector(3 downto 0);
    signal O2: std_logic_vector(3 downto 0);
    signal q1: std_logic_vector(3 downto 0) := "1110";
    signal q2: std_logic_vector(3 downto 0) := "1101";
    signal q3: std_logic_vector(3 downto 0) := "1011";
    signal q4: std_logic_vector(3 downto 0) := "0111";
    signal led : std_logic_vector(6 downto 0);
begin

    process (clk)
    begin
        if clk='1' and clk'event then
            --if en="11111" then
            counter_out <= counter_out + 1;
        end if;
        --end if;
    end process;

    process(counter_out(15 downto 14), digit0, digit1, digit2, digit3)
    begin
        case counter_out(15 downto 14) is
            when "00" => O1 <= digit0;
            when "01" => O1 <= digit1;
            when "10" => O1 <= digit2;
            when others => O1 <= digit3;
        end case;
    end process;

    with O1 SELect
 led<= "1111001" when "0001",   --1
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

    process(counter_out(15 downto 14), q1, q2, q3, q4 )
    begin
        case counter_out(15 downto 14) is
            when "00" => O2 <= q1;
            when "01" => O2 <= q2;
            when "10" => O2 <= q3;
            when others => O2 <= q4;
        end case;
    end process;

    an <= O2;
    cat <= led;

end Behavioral;