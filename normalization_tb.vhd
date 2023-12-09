library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity normalization_tb is
    --  Port ( );
end normalization_tb;

architecture Behavioral of normalization_tb is

    component normalization_unit is
        Port (mantissa_in: in std_logic_vector(47 downto 0);
             exponent_in: in std_logic_vector(7 downto 0);
             clk: in std_logic;
             --en: in std_logic;
             mantissa_out: out std_logic_vector(22 downto 0);
             exponent_out: out std_logic_vector(7 downto 0));
             --done: out std_logic);
    end component;

    signal mantissa_out: std_logic_vector(22 downto 0):=(others => '0');
    signal mantissa_in: std_logic_vector(47 downto 0):=(others => '0');
    signal exponent_in, exponent_out: std_logic_vector(7 downto 0):=(others => '0');
    signal clk, en: std_logic;

begin

--    clk <= '0', '1' after 5 ns, '0' after 10 ns, '1' after 15 ns, '0' after 20 ns, '1' after 25 ns, '0' after 30 ns, '1' after 35 ns, '0' after 40 ns, '1' after 45 ns, '0'after 50 ns, '1' after 55 ns;
--    mantissa_in <= "010000010000000000000000000001100000000000000000", "110010000000100000000000000000000000000000000000" after 10 ns, "10000000000000100000000000000000000000000000000" after 20 ns, 
--    "010000010000000000000000000000000110000000000000" after 30 ns, "0000000000000000000000" after 40 ns, "010101011000000000000000000000000000000000000000" after 50 ns;
--    exponent_in <= "00000010", "00010001" after 10 ns, "10010001" after 20 ns, "00000001" after 30 ns, "01101100" after 40 ns;
--    --en <= '1', '0'after 20 ns, '1' after 30 ns;
    DUT: normalization_unit port map (mantissa_in, exponent_in, clk, mantissa_out, exponent_out);
    
    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
     process
    begin
        mantissa_in <= "000000000000000000000000000000000000001010100100";
        exponent_in <= "01101000";
        wait for 10 ns;
        assert mantissa_out = "00000000000000000000000" and exponent_out = "01101000" report "Test 1 failed" severity failure;
        assert mantissa_out /= "00000000000000000000000" or exponent_out /= "01101000" report "Test 1 passed" severity note;
        
        mantissa_in <= "000000000000000000000000000000000000000000000000";
        exponent_in <= "01101010";
        wait for 10 ns;
        assert mantissa_out = "00000000000000000000000" and exponent_out = "01101010" report "Test 2 failed" severity failure;
        assert mantissa_out /= "00000000000000000000000" or exponent_out /= "01101010" report "Test 2 passed" severity note;
        
        mantissa_in <= "101000000000000000000000100000000000000000000000";
        exponent_in <= "00000001";
        wait for 10 ns;
        assert mantissa_out = "01000000000000000000001" and exponent_out = "00000010" report "Test 3 failed" severity failure;
        assert mantissa_out /= "01000000000000000000001" or exponent_out /= "00000010" report "Test 3 passed" severity note;
        
        mantissa_in <= "101000000000000000000000000000000000000000000000";
        exponent_in <= "00000001";
        wait for 10 ns;
        assert mantissa_out = "01000000000000000000000" and exponent_out = "00000010" report "Test 4 failed" severity failure;
        assert mantissa_out /= "01000000000000000000000" or exponent_out /= "00000010" report "Test 4 passed" severity note;
        
        wait;

    end process;

end Behavioral;
