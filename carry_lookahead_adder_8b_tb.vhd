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
        B <= "10110101";  
        Cin <= '0';       

        Expected_Sum <= "00010000";
        Expected_Cout <= '0';


        assert Sum = Expected_Sum and Cout = Expected_Cout
            report "Test Failed!"
            severity ERROR;

        report "Test Passed!" severity NOTE;
        wait;
    end process stimulus;
end architecture tb;

