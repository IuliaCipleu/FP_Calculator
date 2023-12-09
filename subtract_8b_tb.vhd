library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity subtract_8b_tb is
    --  Port ( );
end subtract_8b_tb;

architecture Behavioral of subtract_8b_tb is
    component subtract_8b is
        Port (
            A: in std_logic_vector(7 downto 0);
            B: in std_logic_vector(7 downto 0);
            Sub: out std_logic_vector(7 downto 0);
            Borrow: out std_logic
        );
    end component;
    
    signal A, B, Sub, Expected_Diff: std_logic_vector(7 downto 0);
    signal Borrow, Expected_Borrow: std_logic;
begin

    stimulus: process
    begin
        A <= "01011011";
        B <= "11110101";

        Expected_Diff <= "01100110";
        Expected_Borrow <= '1';
        wait for 10 ns;
        assert Sub = Expected_Diff and Borrow = Expected_Borrow
        report "Test 1 Failed!" severity ERROR;
        report "Test 1 Passed!" severity NOTE;
        
        A <= "00010100";
        B <= "00001110";

        Expected_Diff <= "00000110";
        Expected_Borrow <= '0';
        wait for 10 ns;
        assert Sub = Expected_Diff and Borrow = Expected_Borrow
        report "Test 2 Failed!" severity ERROR;
        report "Test 2 Passed!" severity NOTE;
        
        A <= "11101011";
        B <= "10111110";

        Expected_Diff <= "00101101";
        Expected_Borrow <= '0';
        wait for 10 ns;
        assert Sub = Expected_Diff and Borrow = Expected_Borrow
        report "Test 3 Failed!" severity ERROR;
        report "Test 3 Passed!" severity NOTE;
        
        A <= "00011000";
        B <= "00011111";

        Expected_Diff <= "11111001";
        Expected_Borrow <= '1';
        wait for 10 ns;
        assert Sub = Expected_Diff and Borrow = Expected_Borrow
        report "Test 4 Failed!" severity ERROR;
        report "Test 4 Passed!" severity NOTE;
        wait;
    end process stimulus;
    
    DUT: subtract_8b port map(A, B, Sub, Borrow);

end Behavioral;
