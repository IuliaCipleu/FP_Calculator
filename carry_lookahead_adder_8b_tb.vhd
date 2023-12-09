library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_lookahead_adder_8b_tb is
end carry_lookahead_adder_8b_tb;

architecture tb of carry_lookahead_adder_8b_tb is
    signal A, B, Sum : std_logic_vector(7 downto 0);
    signal Cin, Cout, Expected_Cout: std_logic;
    signal Expected_Sum: std_logic_vector(7 downto 0);

    component carry_lookahead_adder_8b is
        Port ( A: in std_logic_vector(7 downto 0);
             B: in std_logic_vector(7 downto 0);
             Cin: in std_logic;
             Sum: out std_logic_vector(7 downto 0);
             Cout: out std_logic
            );
    end component;

begin
    uut: carry_lookahead_adder_8b
        port map (
            A => A,
            B => B,
            Sum => Sum,
            Cout => Cout,
            Cin => Cin
        );

    stimulus: process
    begin
        A <= "01011011";
        B <= "11110101";
        Cin <= '0';

        Expected_Sum <= "01010000";
        Expected_Cout <= '1';
        wait for 10 ns;
        assert Sum = Expected_Sum and Cout = Expected_Cout
        report "Test 1 Failed!" severity ERROR;
        report "Test 1 Passed!" severity NOTE;
        
        A <= "00010100";
        B <= "00001110";
        Cin <= '0';

        Expected_Sum <= "00100010";
        Expected_Cout <= '0';
        wait for 10 ns;
        assert Sum = Expected_Sum and Cout = Expected_Cout
        report "Test 2 Failed!" severity ERROR;
        report "Test 2 Passed!" severity NOTE;
        
        A <= "11101011";
        B <= "10111110";
        Cin <= '1';

        Expected_Sum <= "10101010";
        Expected_Cout <= '1';
        wait for 10 ns;
        assert Sum = Expected_Sum and Cout = Expected_Cout
        report "Test 3 Failed!" severity ERROR;
        report "Test 3 Passed!" severity NOTE;
        
        A <= "00011000";
        B <= "00011111";
        Cin <= '1';

        Expected_Sum <= "00111000";
        Expected_Cout <= '0';
        wait for 10 ns;
        assert Sum = Expected_Sum and Cout = Expected_Cout
        report "Test 4 Failed!" severity ERROR;
        report "Test 4 Passed!" severity NOTE;
        
        wait;
    end process stimulus;
end architecture tb;

