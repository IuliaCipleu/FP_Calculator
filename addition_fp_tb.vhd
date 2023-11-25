----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2023 07:54:56 PM
-- Design Name: 
-- Module Name: addition_fp_tb - Behavioral
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

entity addition_fp_tb is
--  Port ( );
end addition_fp_tb;

architecture Behavioral of addition_fp_tb is
    component addition_fp is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
         B : in STD_LOGIC_VECTOR (31 downto 0);
         clk: in std_logic;
         Sum : out STD_LOGIC_VECTOR (31 downto 0);
         Overflow_flag: out std_logic);
end component;

    signal clk, Overflow_flag: std_logic := '0';
    signal A, B: std_logic_vector(31 downto 0);
    signal Sum: std_logic_vector(31 downto 0);
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
        
        A <= "00000000000000000000000000000000"; -- 0
        B <= "00000000000000000000000000000000"; -- 0
        wait for 10 ns;
        report "Expected result 0 = 0"; 
        
        
        A <= "01000000100000000000000000000000"; -- 4
        B <= "01000001000000000000000000000000"; -- 8
        wait for 10 ns;
        report "Expected result 12"; 
        
        A <= "00000001001000000000000000000000"; -- 2.938735877055
        B <= "00111111100000000000000000000000"; -- 1
        wait for 10 ns;
        report "Expected result 3.938735877055"; 
        
        
         A <= "01000001101001000000000000000000"; -- 20.5
        B <= "01000000000000000000000000000000"; -- 2.0
        wait for 10 ns;
        report "Expected result 22.5";

        A <= "11000000000000000000000000000000"; -- -2.0
        B <= "01000001000111000000000000000000"; -- 9.75
        wait for 10 ns;
        report "Expected result 7.750";
        
        
        A <= "01000000011001100110011001100110"; -- 3.6
        B <= "01000001001000000000000000000000"; -- 10.0
        wait for 10 ns;
        report "Expected result 13.6";

        A <= "11000000100001100110011001100110"; -- -4.2
        B <= "11000000010100000000000000000000"; -- -3.25
        wait for 10 ns;
        report "Expected result -7.45";
       

        wait;
    end process;
    
    DUT: addition_fp port map (A, B, clk, Sum, Overflow_flag);


end Behavioral;
