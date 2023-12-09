library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_register_generic is
end tb_register_generic;

architecture testbench of tb_register_generic is
    component register_generic is
    generic (
        WIDTH: positive := 32
    );
    Port (
        d : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
        ld : in STD_LOGIC; 
        clear : in STD_LOGIC; 
        clk : in STD_LOGIC; 
        q : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0) 
    );
end component;
    constant WIDTH : positive := 32;

    signal d : STD_LOGIC_VECTOR(WIDTH - 1 downto 0) := (others => '0');
    signal ld, clear, clk : STD_LOGIC := '0';
    signal q : STD_LOGIC_VECTOR(WIDTH - 1 downto 0):= (others => '0');

begin
    UUT: register_generic
        generic map (WIDTH => WIDTH)
        port map (d => d, ld => ld, clear => clear, clk => clk, q => q);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    stimulus: process
    begin
        -- Test 1: Load data when ld = '1'
        d <= "10101010101010101010101010101010";
        ld <= '1';
        clear <= '0';
        wait for 10 ns;
        assert q = "10101010101010101010101010101010" report "Test 1 failed" severity failure;
        assert q /= "10101010101010101010101010101010" report "Test 1 passed" severity note;
        
        -- Test 2: Clear the register when clear = '1'
        clear <= '1';
        ld <= '0';
        wait for 10 ns;
        assert q = "00000000000000000000000000000000" report "Test 2 failed" severity failure;
        assert q /= "00000000000000000000000000000000" report "Test 2 passed" severity note;
        
        -- Test 3: Do nothing when ld = '0' and clear = '0'
        ld <= '0';
        clear <= '0';
        wait for 10 ns;
        assert q = "00000000000000000000000000000000" report "Test 3 failed" severity failure;
        assert q /= "00000000000000000000000000000000" report "Test 3 passed" severity note;

        -- Test 4: Load new data when ld = '1' (after clear)
        d <= "11001100110011001100110011001100";
        ld <= '1';
        clear <= '0';
        wait for 10 ns;
        assert q = "11001100110011001100110011001100" report "Test 4 failed" severity failure;
        assert q /= "11001100110011001100110011001100" report "Test 4 passed" severity note;

        wait;
    end process stimulus;

end testbench;
