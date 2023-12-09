----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2023 05:44:18 PM
-- Design Name: 
-- Module Name: two_compl_to_binary_tb - Behavioral
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

entity two_compl_to_binary_tb is
    --  Port ( );
end two_compl_to_binary_tb;

architecture Behavioral of two_compl_to_binary_tb is
    component TwosComplementToBinary is
        Port (
            twosComplementInput : in STD_LOGIC_VECTOR(47 downto 0);
            binaryOutput : out STD_LOGIC_VECTOR(47 downto 0)
        );
    end component;

    signal twosComplementInput, binaryOutput: std_logic_vector(47 downto 0);
begin

    --twosComplementInput <= "000000000000000000000000000000000000000000011001", "111111111111111111111111111111111111111111100111" after 10 ns, "111111111111111111111111111111111111111110000011" after 20 ns, 
    --"000000000000000000000000000000000000000000000000" after 30 ns, "000000000000000000000000000000000001100111101010" after 40 ns; -- 25, -25, -125, 0, 6634

    process
    begin
        twosComplementInput <= "000000000000000000000000000000000000000000011000"; -- 24
        wait for 10 ns;
        assert binaryOutput = "000000000000000000000000000000000000000000011000" report "Test 1 failed" severity failure;
        assert binaryOutput /= "000000000000000000000000000000000000000000011000" report "Test 1 passed" severity note;
        
        twosComplementInput <= "000000000000000000000000000000000000000000001011"; -- 11
        wait for 10 ns;
        assert binaryOutput = "000000000000000000000000000000000000000000001011" report "Test 2 failed" severity failure;
        assert binaryOutput /= "000000000000000000000000000000000000000000001011" report "Test 2 passed" severity note;
        
        twosComplementInput <= "000000000000000000000000000000000000000000000101"; -- -5
        wait for 10 ns;
        assert binaryOutput = "000000000000000000000000000000000000000000000101" report "Test 3 failed" severity failure;
        assert binaryOutput /= "000000000000000000000000000000000000000000000101" report "Test 3 passed" severity note;

    end process;

    DUT: TwosComplementToBinary port map (twosComplementInput, binaryOutput);

end Behavioral;
