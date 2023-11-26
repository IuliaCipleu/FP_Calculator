library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addition_tb is
    -- Port ();
end addition_tb;

architecture Behavioral of addition_tb is
    component addition is
        port(A: in  std_logic_vector(31 downto 0);
             B: in  std_logic_vector(31 downto 0);
             clk: in  std_logic;
             reset: in  std_logic;
             start: in  std_logic;
             done: out std_logic;
             RESULT: out std_logic_vector(31 downto 0)
            );
    end component;

    signal clk, reset, start, done: std_logic;
    signal A, B, RESULT: std_logic_vector(31 downto 0):= (others => '0');
    constant period: time := 10 ns;

begin
    uut: addition
        port map (
            A => A,
            B => B,
            clk => clk,
            reset => reset,
            start => start,
            done => done,
            Result => Result
        );

    clk_process: process
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;

    stimulus: process
    begin
    
    -- Test Case 0: A=0, B=0 (Expected Result: 0)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "00000000000000000000000000000000";
        B <= "00000000000000000000000000000000";
        reset <= '0';
        start <= '1';
        wait for period;
        --wait until done = '1';
        
        -- Positive Assertion: Check for Correct Result
        assert Result /= "00000000000000000000000000000000"
        report "Test 0 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Result = "00000000000000000000000000000000"
        report "Test 0 failed: Incorrect result"
        severity error;
        wait for 2 * period;
        
        -- Test Case 1: A=3.5, B=6.75 (Expected Result: 10.25)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000000011000000000000000000000";
        B <= "01000000110110000000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';

        -- Positive Assertion: Check for Correct Result
        assert Result /= "01000001001001000000000000000000"
        report "Test 1 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Result = "01000001001001000000000000000000"
        report "Test 1 failed: Incorrect result"
        severity error;   

        -- Test Case 2: A=-1.625, B=9.0625 (Expected Result: 7.4375)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "10111111110100000000000000000000";
        B <= "01000001000100010000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';

        -- Positive Assertion: Check for Correct Result
        assert Result /= "01000000111011100000000000000000"
        report "Test 2 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Result = "01000000111011100000000000000000"
        report "Test 2 failed: Incorrect result"
        severity error;

        -- Test Case 3: A=-104.015625, B=-5.5 (Expected Result: -109.515625)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "11000010110100000000100000000000";
        B <= "11000000101100000000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';

        -- Positive Assertion: Check for Correct Result
        assert Result /= "11000010110110110000100000000000"
        report "Test 3 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Result = "11000010110110110000100000000000"
        report "Test 3 failed: Incorrect result"
        severity error;

        -- Test Case 4: A=21.7499999999999999999, B=-8.49999999999999 (Expected Result: 13.25)
       
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000001101011100000000000000000";
        B <= "11000001000010000000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';

        -- Positive Assertion: Check for Correct Result
        assert Result /= "01000001010101000000000000000000"
        report "Test 4 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Result = "01000001010101000000000000000000"
        report "Test 4 failed: Incorrect result"
        severity error;
        
        -- Test Case 5: A=2.0, B=2.0 (Expected Result: 4.0)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000000000000000000000000000000";
        B <= "01000000000000000000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';

        -- Positive Assertion: Check for Correct Result
        assert Result /= "01000000100000000000000000000000"
        report "Test 5 passed: Correct result"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Result = "01000000100000000000000000000000"
        report "Test 5 failed: Incorrect result: 40800000"
        severity error;        

        wait;
    end process;

end Behavioral;

