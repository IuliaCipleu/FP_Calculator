----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2023 01:29:25 PM
-- Design Name: 
-- Module Name: testbench_all - Behavioral
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

    signal clk, overflow_flag_mult, overflow_flag_add, done, reset, start: std_logic := '0';
    signal A, B: std_logic_vector(31 downto 0);
    signal ProductBehavioral, ProductStructural, SumBehavioral, SumStructural: std_logic_vector(31 downto 0);
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
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 0 = 0";
        report "Expected product 0 = 0";

        A <= "00000000000000000000000000000000"; -- 0
        B <= "00000000000000000000000000000000"; -- 0
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 0 = 0";
        report "Expected product 0 = 0";

        A <= "01000000100000000000000000000000"; -- 4
        B <= "01000001000000000000000000000000"; -- 8
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 12 = 41400000";
        report "Expected product 32 = 42000000";

        A <= "01000000100000000000000000000000"; -- 4
        B <= "01000001000000000000000000000000"; -- 8
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 12 = 41400000";
        report "Expected product 32 = 42000000";


        A <= "01000001101001000000000000000000"; -- 20.5
        B <= "01000000000000000000000000000000"; -- 2.0
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 22.5 = 41b40000";
        report "Expected product 41.0 = 42240000";

        A <= "01000001101001000000000000000000"; -- 20.5
        B <= "01000000000000000000000000000000"; -- 2.0
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 22.5 = 41b40000";
        report "Expected product 41.0 = 42240000";

        A <= "11000000000000000000000000000000"; -- -2.0
        B <= "01000001000111000000000000000000"; -- 9.75
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 7.75 = 40f80000";
        report "Expected product -19.5 = 19c0000";

        A <= "11000000000000000000000000000000"; -- -2.0
        B <= "01000001000111000000000000000000"; -- 9.75
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 7.75 = 40f80000";
        report "Expected product -19.5 = 19c0000";

        A <= "01000000011001100110011001100110"; -- 3.6
        B <= "01000001001000000000000000000000"; -- 10.0
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 13.6 = 4159999a";
        report "Expected product 36 = 42100000";

        A <= "01000000011001100110011001100110"; -- 3.6
        B <= "01000001001000000000000000000000"; -- 10.0
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum 13.6 = 4159999a";
        report "Expected product 36 = 42100000";

        A <= "11000000100001100110011001100110"; -- -4.2
        B <= "11000000010100000000000000000000"; -- -3.25
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum -7.45 = c0ee6666";
        report "Expected product 13.65 = 415a6666";

        A <= "11000000100001100110011001100110"; -- -4.2
        B <= "11000000010100000000000000000000"; -- -3.25
        --wait for 10 ns;
        reset <= '1';
        start <= '0';
        wait for 2 * CLOCK_PERIOD;
        reset <= '0';
        start <= '1';
        wait until done = '1';
        report "Expected sum -7.45 = c0ee6666";
        report "Expected product 13.65 = 415a6666";

        wait;
    end process;
    DUT1: multiplication_fp
        port map (
            A => A,
            B => B,
            Product => ProductStructural,
            overflow_flag => overflow_flag_mult,
            clk => clk
        );

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

    DUT4: addition_fp
        port map (
            A => A,
            B => B,
            clk => clk,
            Sum => SumStructural,
            overflow_flag => overflow_flag_add
        );

end Behavioral;
