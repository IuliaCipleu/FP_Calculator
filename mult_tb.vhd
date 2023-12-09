library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.CONSTANTS.ALL;

entity mult_tb is
end mult_tb;

architecture behavior of mult_tb is

    component multiplication_fp is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
         B : in STD_LOGIC_VECTOR (31 downto 0);
         Product : out STD_LOGIC_VECTOR (31 downto 0);
         overflow_flag: out std_logic;
         clk: in std_logic);
end component;

    signal clk, overflow_flag: std_logic := '0';
    signal A, B: std_logic_vector(31 downto 0);
    signal Product: std_logic_vector(31 downto 0);
    constant  period: time := 10 ns;
    begin
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
        
        A <= "00000000000000000000000000000000";
        B <= "00000000000000000000000000000000";
        wait for period;
        
        -- Positive Assertion: Check for Correct Result
        assert Product /= "00000000000000000000000000000000"
        report "Test 0 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Product = "00000000000000000000000000000000"
        report "Test 0 failed: Incorrect product"
        severity error;
        --wait for 2 * period;
        
        -- Test Case 1: A=3.5, B=6.75 (Expected Result: 10.25)
        
        wait for period;
        A <= "01000000011000000000000000000000";
        B <= "01000000110110000000000000000000";

        
        -- Positive Assertion: Check for Correct Result
        assert Product /= "01000001101111010000000000000000"
        report "Test 1 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Product = "01000001101111010000000000000000"
        report "Test 1 failed: Incorrect product"
        severity error;  

        -- Test Case 2: A=-1.625, B=9.0625 (Expected Result: 7.4375)
        
        wait for period;
        A <= "10111111110100000000000000000000";
        B <= "01000001000100010000000000000000";
        
        -- Positive Assertion: Check for Correct Result
        assert Product /= "11000001011010111010000000000000"
        report "Test 2 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Product = "11000001011010111010000000000000"
        report "Test 2 failed: Incorrect product"
        severity error;

        -- Test Case 3: A=-104.015625, B=-5.5 (Expected Result: -109.515625)
    wait for period;
        A <= "11000010110100000000100000000000";
        B <= "11000000101100000000000000000000";

        
        -- Positive Assertion: Check for Correct Result
        assert Product /= "01000100000011110000010110000000"
        report "Test 3 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Product = "01000100000011110000010110000000"
        report "Test 3 failed: Incorrect product"
        severity error;

        -- Test Case 4: A=21.7499999999999999999, B=-8.49999999999999 (Expected Result: 13.25)
       
        wait for period;
        A <= "01000001101011100000000000000000";
        B <= "11000001000010000000000000000000";
        
        -- Positive Assertion: Check for Correct Result
        assert Product /= "11000011001110001110000000000000"
        report "Test 4 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Product = "11000011001110001110000000000000"
        report "Test 4 failed: Incorrect product"
        severity error;
        
        -- Test Case 5: A=2.0, B=2.0 (Expected Result: 4.0)

        wait for period;
        A <= "01000000000000000000000000000000";
        B <= "01000000000000000000000000000000"; 
        
        -- Positive Assertion: Check for Correct Result
        assert Product /= "01000000100000000000000000000000"
        report "Test 5 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Product = "01000000100000000000000000000000"
        report "Test 5 failed: Incorrect product"
        severity error; 
        
        -- Test Case 6: A=min, B=min (Expected Result: overflow)

        wait for period;
        A <= "11111111111111111111111111111111";
        B <= "11111111111111111111111111111111";

        
        -- Positive Assertion: Check for Correct Result
        assert Product /= "01111111100000000000000000000000"
        report "Test 6 passed: Correct product: overflow"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Product = "01111111100000000000000000000000"
        report "Test 6 failed: Incorrect product"
        severity error;
        
        -- Test Case 7: A=645.86, B=1005.63 (Expected Result: overflow)

        wait for period;
        A <= "01000100001000010111011100001010";
        B <= "01000100011110110110100001010010";

        
        -- Positive Assertion: Check for Correct Result
        assert Product /= "01001001000111101001000110000011"
        report "Test 7 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert Product = "01001001000111101001000110000011"
        report "Test 7 failed: Incorrect product"
        severity error;     

        wait;
    end process;
    
    DUT: multiplication_fp
        port map (
            A => A,
            B => B,
            Product => Product,
            overflow_flag => overflow_flag,
            clk => clk
            
        );
end behavior;
