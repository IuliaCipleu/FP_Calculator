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
        wait for 10 ns;
        assert p = "000000000000000000000000000000000000000000000000" report "Test 1 failed" severity failure;
        assert p /= "000000000000000000000000000000000000000000000000" report "Test 1 passed" severity note;

        a <= "000000000000000000000010"; -- 2
        b <= "111111111111111111111011"; -- -5
        wait for 10 ns;
        assert p = "111111111111111111111111111111111111111111110110" report "Test 2 failed" severity failure;
        assert p /= "111111111111111111111111111111111111111111110110" report "Test 2 passed" severity note;

        a <= "111111111111110101101110"; -- -658
        b <= "111111111111111100111000"; -- -200
        wait for 10 ns;
        assert p = "000000000000000000000000000000100000001000010000" report "Test 3 failed" severity failure;
        assert p /= "000000000000000000000000000000100000001000010000" report "Test 3 passed" severity note;

        a <= "000000001011110110111101"; -- 48573
        b <= "000000000000000001111101"; -- 125
        wait for 10 ns;
        assert p = "000000000000000000000000010111001010010101001001" report "Test 4 failed" severity failure;
        assert p /= "000000000000000000000000010111001010010101001001" report "Test 4 passed" severity note;

--        a <= "100000000000000000001010";
--        b <= "100000000000000000000010";
--        wait for 10 ns;
        
--        a <= "000000000000000000001010";
--        b <= "000000000000000000000010";
--        wait for 10 ns;

        wait;
    end process;
end behavior;
