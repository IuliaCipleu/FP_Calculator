----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2023 05:24:04 PM
-- Design Name: 
-- Module Name: multiplier_behavioral_testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier_behavioral_testbench is
--  Port ( );
end multiplier_behavioral_testbench;

architecture Behavioral of multiplier_behavioral_testbench is
component multiplier_behavioral is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
         y : in  STD_LOGIC_VECTOR (31 downto 0);
         clk: in std_logic;
         z : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal clk: std_logic := '0';
signal A, B, z: std_logic_vector(31 downto 0);
constant period: time := 10 ns;
begin

clk_process: process
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for  period / 2;
    end process;
    
    stim_process: process
    begin
        A <= "01000001101001000000000000000000"; -- 20.5
        B <= "01000000000000000000000000000000"; -- 2.0
        wait for 10 ns;
        assert z /= "01000010001001000000000000000000"
        report "Test 1 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert z = "01000010001001000000000000000000"
        report "Test 1 failed: Incorrect result"
        severity error;

        A <= "11000000000000000000000000000000"; -- -2.0
        B <= "01000001000111000000000000000000"; -- 9.75
        wait for 10 ns;
        assert z /= "11000001100111000000000000000000"
        report "Test 2 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert z = "11000001100111000000000000000000"
        report "Test 2 failed: Incorrect result"
        severity error;

        A <= "01000000011001100110011001100110"; -- 3.6
        B <= "01000001001000000000000000000000"; -- 10.0
        wait for 10 ns;
        assert z /= "01000010000100000000000000000000"
        report "Test 3 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert z = "01000010000100000000000000000000"
        report "Test 3 failed: Incorrect result"
        severity error;

        A <= "11000000100001100110011001100110"; -- -4.2
        B <= "11000000010100000000000000000000"; -- -3.25
        wait for 10 ns;
        assert z /= "01000001010110100110011001100110"
        report "Test 4 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert z = "01000001010110100110011001100110"
        report "Test 4 failed: Incorrect result"
        severity error;

        wait;
    end process;
    
    DUT: multiplier_behavioral
        port map (
            x => A,
            y => B,
            clk => clk,
            z => z
        );

end Behavioral;
