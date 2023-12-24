library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench_all is
    --  Port ( );
end testbench_all;

architecture Behavioral of testbench_all is

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

    component multiplier_behavioral is
        Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
             y : in  STD_LOGIC_VECTOR (31 downto 0);
             clk: in std_logic;
             z : out  STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component multiplication_fp is
        Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
             B : in STD_LOGIC_VECTOR (31 downto 0);
             Product : out STD_LOGIC_VECTOR (31 downto 0);
             overflow_flag: out std_logic;
             clk: in std_logic);
    end component;

    component addition_fp is
        Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
             B : in STD_LOGIC_VECTOR (31 downto 0);
             clk: in std_logic;
             Sum : out STD_LOGIC_VECTOR (31 downto 0);
             Overflow_flag: out std_logic);
    end component;

    signal clk, done, reset, start: std_logic := '0';
    signal A, B: std_logic_vector(31 downto 0);
    signal ProductBehavioral, SumBehavioral,  expectedSum, expectedProduct: std_logic_vector(31 downto 0);
    --diffSum, diffProduct,
    constant period: time := 10 ns;

begin

    clk_process: process
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;

--        diffSum <= SumBehavioral - expectedSum;
--        diffProduct <= ProductBehavioral - expectedProduct;


    stimulus: process
    begin
    
    -- Test Case 0: A=0, B=0 (Expected Result: 0)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "00000000000000000000000000000000";
        B <= "00000000000000000000000000000000";
        
        expectedProduct <= "00000000000000000000000000000000";
        expectedSum <= "00000000000000000000000000000000";
        reset <= '0';
        start <= '1';
        wait for period;
       
        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 0 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 0 failed: Incorrect sum"
        severity error;
        wait for 2 * period;
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 0 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 0 failed: Incorrect product"
        severity error;
        --wait for 2 * period;
        
        -- Test Case 1: A=3.5, B=6.75 (Expected Result: 10.25)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000000011000000000000000000000";
        B <= "01000000110110000000000000000000";

        expectedProduct <= "01000001101111010000000000000000";
        expectedSum <= "01000001001001000000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';
                
        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 1 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 1 failed: Incorrect sum"
        severity error; 
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 1 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 1 failed: Incorrect product"
        severity error;  

        -- Test Case 2: A=-1.625, B=9.0625 (Expected Result: 7.4375)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "10111111110100000000000000000000";
        B <= "01000001000100010000000000000000";
        
        expectedProduct <= "11000001011010111010000000000000";
        expectedSum <= "01000000111011100000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';
           
        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 2 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 2 failed: Incorrect sum"
        severity error;
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 2 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 2 failed: Incorrect product"
        severity error;

        -- Test Case 3: A=-104.015625, B=-5.5 (Expected Result: -109.515625)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "11000010110100000000100000000000";
        B <= "11000000101100000000000000000000";
        
        expectedProduct <= "01000100000011110000010110000000";
        expectedSum <= "11000010110110110000100000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';
        
        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 3 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 3 failed: Incorrect sum"
        severity error;
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 3 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 3 failed: Incorrect product"
        severity error;

        -- Test Case 4: A=21.7499999999999999999, B=-8.49999999999999 (Expected Result: 13.25)
       
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000001101011100000000000000000";
        B <= "11000001000010000000000000000000";
        
        expectedProduct <= "11000011001110001110000000000000";
        expectedSum <= "01000001010101000000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';

        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 4 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 4 failed: Incorrect sum"
        severity error;
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 4 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 4 failed: Incorrect product"
        severity error;
        
        -- Test Case 5: A=2.0, B=2.0 (Expected Result: 4.0)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000000000000000000000000000000";
        B <= "01000000000000000000000000000000";
        
        expectedProduct <= "01000000100000000000000000000000";
        expectedSum <= "01000000100000000000000000000000";
        reset <= '0';
        start <= '1';
        wait until done = '1';

        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 5 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 5 failed: Incorrect sum"
        severity error;  
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 5 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 5 failed: Incorrect product"
        severity error; 
        
        -- Test Case 6: A=min, B=min (Expected Result: overflow)
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "11111111111111111111111111111111";
        B <= "11111111111111111111111111111111";
        
        expectedProduct <= "01111111100000000000000000000000";
        expectedSum <= "10000000011111111111111111111111";
        reset <= '0';
        start <= '1';
        wait until done = '1';
        
        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 6 passed: Correct sum: overflow"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 6 failed: Incorrect sum"
        severity error;  
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 6 passed: Correct product: overflow"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 6 failed: Incorrect product"
        severity error;
        
        -- Test Case 7: A=645.86, B=1005.63 
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000100001000010111011100001010";
        B <= "01000100011110110110100001010010";
        
        expectedProduct <= "01001001000111101001000110000011";
        expectedSum <= "01000100110011100110111110101110";
        reset <= '0';
        start <= '1';
        wait until done = '1';        

        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 7 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 7 failed: Incorrect sum"
        severity error;  
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 7 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 7 failed: Incorrect product"
        severity error; 
        
        -- Test Case 8: A=482.7453742, B=-374.0463517 
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000011111100010101111101101000"; --43f15f68
        B <= "11000011101110110000010111101111"; --c3bb05ef
        
        expectedProduct <= "11001000001100000101011001001001"; -- -180569.14601956130614
        expectedSum <= "01000010110110010110010111100110"; -- 108.6990225
        reset <= '0';
        start <= '1';
        wait until done = '1';               

        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 8 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 8 failed: Incorrect sum"
        severity error;  
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 8 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 8 failed: Incorrect product"
        severity error;    
        
        -- Test Case 9: A=-69427.27498, B=-943724.9543672 
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "11000111100001111001100110100011";
        B <= "11001001011001100110011011001111";
        
        expectedProduct <= "01010001011101000001010011111011"; -- 65520251912.339546292656
        expectedSum <= "11001001011101110101101000000100"; -- -1013152.2293472
        reset <= '0';
        start <= '1';
        wait until done = '1';
              
        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 9 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 9 failed: Incorrect sum"
        severity error;  
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 9 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 9 failed: Incorrect product"
        severity error;    
        
        -- Test Case 10: A=56.33, B=-364.66 
        
        reset <= '1';
        start <= '0';
        wait for period;
        A <= "01000010011000010101000111101100"; -- 426151ec
        B <= "11000011101101100101010001111011"; -- c3b6547b
        
        expectedProduct <= "11000110101000000111101010011000"; -- -20541.2978      
        expectedSum <= "11000011100110100010101000111101"; -- -308.33
        reset <= '0';
        start <= '1';
        wait until done = '1';
              
        -- Positive Assertion: Check for Correct Result
        assert SumBehavioral /= expectedSum
        report "Test 10 passed: Correct sum"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert SumBehavioral = expectedSum
        report "Test 10 failed: Incorrect sum"
        severity error;  
        
        -- Positive Assertion: Check for Correct Result
        assert ProductBehavioral /= expectedProduct
        report "Test 10 passed: Correct product"
        severity note;

        -- Negative Assertion: Check for Incorrect Result
        assert ProductBehavioral = expectedProduct
        report "Test 10 failed: Incorrect product"
        severity error; 

        wait;
    end process;
--    DUT1: multiplication_fp
--        port map (
--            A => A,
--            B => B,
--            Product => ProductStructural,
--            overflow_flag => overflow_flag_mult,
--            clk => clk
--        );

    DUT2: multiplier_behavioral
        port map (
            x => A,
            y => B,
            clk => clk,
            z => ProductBehavioral
        );

    DUT3: addition
        port map (
            A => A,
            B => B,
            clk => clk,
            reset => reset,
            start => start,
            done => done,
            RESULT => SumBehavioral
        );

--    DUT4: addition_fp
--        port map (
--            A => A,
--            B => B,
--            clk => clk,
--            Sum => SumStructural,
--            overflow_flag => overflow_flag_add
--        );

end Behavioral;
