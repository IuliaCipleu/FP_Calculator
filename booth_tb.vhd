library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.CONSTANTS.ALL;

entity booth_tb is
end booth_tb;

architecture behavior of booth_tb is
    signal a, b : std_logic_vector(NumBit-1 downto 0);
    signal p : std_logic_vector(2*NumBit-1 downto 0);

    component booth_mul
        generic (NBIT: integer := NumBit);
        port (a: in std_logic_vector(NBIT-1 downto 0);
             b: in std_logic_vector(NBIT-1 downto 0);
             p: out std_logic_vector(2*NBIT-1 downto 0));
    end component;

begin

    uut: booth_mul
        port map (a => a, b => b, p => p);

    process
    begin

        a <= (others => '0');
        b <= (others => '0');

        a <= "100000000000000000011001"; --8388633
        b <= "100000000000000000000101"; --8388613
        wait for 10 ns;

        a <= "100000000000000000000010";
        b <= "100000000000000000000010";
        wait for 10 ns;

        a <= "100000000000000000000010";
        b <= "100000000000000000000100";
        wait for 10 ns;

        a <= "100000000000000000001010";
        b <= "100000000000000000000010";
        wait for 10 ns;
        
        a <= "000000000000000000001010";
        b <= "000000000000000000000010";
        wait for 10 ns;

        wait;
    end process;
end behavior;
