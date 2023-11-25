library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier_behavioral_tb is
end entity multiplier_behavioral_tb;

architecture tb of multiplier_behavioral_tb is
    signal clk: std_logic := '0';
    signal A, B, z: std_logic_vector(31 downto 0);
    component multiplier_behavioral is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
         y : in  STD_LOGIC_VECTOR (31 downto 0);
         clk: in std_logic;
         z : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
    constant CLOCK_PERIOD: time := 10 ns;
    begin
    clk_process: process
    begin
        clk <= '0';
        wait for CLOCK_PERIOD / 2;
        clk <= '1';
        wait for CLOCK_PERIOD / 2;
    end process;
    
    stim_process: process
    begin
        A <= "01000001101001000000000000000000"; -- 20.5
        B <= "01000000000000000000000000000000"; -- 2.0
        wait for 10 ns;
        report "Expected result 41.0 = 42240000";

        A <= "11000000000000000000000000000000"; -- -2.0
        B <= "01000001000111000000000000000000"; -- 9.75
        wait for 10 ns;
        report "Expected result -19.5 = c19c0000";

        A <= "01000000011001100110011001100110"; -- 3.6
        B <= "01000001001000000000000000000000"; -- 10.0
        wait for 10 ns;
        report "Expected result 36 = 42100000";

        A <= "11000000100001100110011001100110"; -- -4.2
        B <= "11000000010100000000000000000000"; -- -3.25
        wait for 10 ns;
        report "Expected result 13.65 = 415a6666";

        wait;
    end process;
    
    DUT: multiplier_behavioral
        port map (
            x => A,
            y => B,
            clk => clk,
            z => z
        );
end architecture tb;
