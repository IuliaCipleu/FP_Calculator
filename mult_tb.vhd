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
        
         A <= "00000000000000000000000000000000"; -- 0
        B <= "00000000000000000000000000000000"; -- 0
        wait for 10 ns;
        report "Expected result 0 = 0";
        
        A <= "01000000100000000000000000000000"; -- 4
        B <= "01000001000000000000000000000000"; -- 8
        wait for 10 ns;
        report "Expected result 32 = 4200 0000";
        
        A <= "01000000100000000000000000000000"; -- 4
        B <= "01000001000000000000000000000000"; -- 8
        wait for 10 ns;
        report "Expected result 32 = 4200 0000"; 
        
        A <= "00000001001000000000000000000000"; -- 2.938735877055
        B <= "00111111100000000000000000000000"; -- 1
        wait for 10 ns;
        report "Expected result 2.938735877055 = 1200000"; 
        
        A <= "00000001001000000000000000000000"; -- 2.938735877055
        B <= "00111111100000000000000000000000"; -- 1
        wait for 10 ns;
        report "Expected result 2.938735877055 = 0x01200000";   
    
        A <= "01000001101001000000000000000000"; -- 20.5
        B <= "01000000000000000000000000000000"; -- 2.0
        wait for 10 ns;
        report "Expected result 41.0 = 42240000";
        
        A <= "01000001101001000000000000000000"; -- 20.5
        B <= "01000000000000000000000000000000"; -- 2.0
        wait for 10 ns;
        report "Expected result 41.0 = 42240000";

        A <= "11000000000000000000000000000000"; -- -2.0
        B <= "01000001000111000000000000000000"; -- 9.75
        wait for 10 ns;
        report "Expected result -19.5 = 19c0000";
        
        A <= "11000000000000000000000000000000"; -- -2.0
        B <= "01000001000111000000000000000000"; -- 9.75
        wait for 10 ns;
        report "Expected result -19.5 = 19c0000";

        A <= "01000000011001100110011001100110"; -- 3.6
        B <= "01000001001000000000000000000000"; -- 10.0
        wait for 10 ns;
        report "Expected result 36 = 42100000";
        
        A <= "01000000011001100110011001100110"; -- 3.6
        B <= "01000001001000000000000000000000"; -- 10.0
        wait for 10 ns;
        report "Expected result 36 = 42100000";

        A <= "11000000100001100110011001100110"; -- -4.2
        B <= "11000000010100000000000000000000"; -- -3.25
        wait for 10 ns;
        report "Expected result 13.65 = 415a6666";
        
        A <= "11000000100001100110011001100110"; -- -4.2
        B <= "11000000010100000000000000000000"; -- -3.25
        wait for 10 ns;
        report "Expected result 13.65 = 415a6666";

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
