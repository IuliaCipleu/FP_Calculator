library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_conv_2_complement is
end tb_conv_2_complement;

architecture testbench of tb_conv_2_complement is
    constant WIDTH : positive := 8;

    signal A : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal A_converted : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    
    component conv_2_complement is
    generic (
        WIDTH: positive := 8
    );
    Port (
        A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
        A_converted : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0)
    );
end component;

begin
    UUT: conv_2_complement
        generic map (WIDTH => WIDTH)
        port map (A => A, A_converted => A_converted);

    stimulus: process
    begin
        -- Test 1: Positive to Two's Complement
        A <= "01010101";
        wait for 10 ns;
        assert A_converted = "10101011" report "Test 1 failed" severity failure;
        assert A_converted /= "10101011" report "Test 1 passed" severity note;

        -- Test 2: Negative to Two's Complement
        A <= "11011010";
        wait for 10 ns;
        assert A_converted = "00100110" report "Test 2 failed" severity failure;
        assert A_converted /= "00100110" report "Test 2 passed" severity note;

        -- Test 3: Zero to Two's Complement
        A <= "00000000";
        wait for 10 ns;
        assert A_converted = "00000000" report "Test 3 failed" severity failure;
        assert A_converted /= "00000000" report "Test 3 passed" severity note;

        -- Test 4: Maximum positive value to Two's Complement
        A <= "01111111";
        wait for 10 ns;
        assert A_converted = "10000001" report "Test 4 failed" severity failure;
        assert A_converted /= "10000001" report "Test 4 passed" severity note;

        -- Test 5: Maximum negative value to Two's Complement
        A <= "10000000";
        wait for 10 ns;
        assert A_converted = "10000000" report "Test 5 failed" severity failure;
        assert A_converted /= "10000000" report "Test 5 passed" severity note;

        wait;
    end process stimulus;

end testbench;
