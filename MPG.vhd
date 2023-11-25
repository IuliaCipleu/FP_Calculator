library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity MPG is
    Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC;
         en : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
    signal cnt : std_logic_vector (15 downto 0) := (others=>'0');
    signal cnt_out : std_logic_vector (15 downto 0) := (others=>'0');
    signal o1 : std_logic;
    signal o2 : std_logic;
    signal o3 : std_logic;
    signal en2 : std_logic;
begin

    process (clk)
    begin
        if rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
    end process;
    cnt_out<=cnt;
    process (clk, cnt_out )
    begin
        if (clk'event and clk='1') then
            if cnt_out(15 downto 0) = "1111111111111111" then
                o1 <= btn;
            end if;
        end if;
    end process;

    process(clk, o1)
    begin
        if rising_edge(clk) then o2<=o1;
        end if;
    end process;

    process(clk, o2)
    begin
        if rising_edge(clk) then o3<=o2;
        end if;
    end process;

    en2 <= o2 and not(o3);
    en <= en2;

end Behavioral;