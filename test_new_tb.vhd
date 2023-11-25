library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_new_tb is
end test_new_tb;

architecture sim of test_new_tb is
    -- Constants
    constant CLOCK_PERIOD : time := 10 ns;

    -- Signals
    signal sw_tb       : std_logic_vector(15 downto 0) := (others => '0');
    signal btn_tb      : std_logic_vector(4 downto 0)  := (others => '0');
    signal clk_tb      : std_logic := '0';
    signal cat_tb      : std_logic_vector(6 downto 0);
    signal an_tb       : std_logic_vector(3 downto 0);
    signal led_tb      : std_logic_vector(15 downto 0);

    signal stimulus_done : boolean := false;

    -- Component instantiation
    component test_new
        Port (
            sw  : in std_logic_vector(15 downto 0);
            btn : in std_logic_vector(4 downto 0);
            clk : in std_logic;
            cat : out std_logic_vector(6 downto 0);
            an  : out std_logic_vector(3 downto 0);
            led : out std_logic_vector(15 downto 0)
        );
    end component;

begin
    -- DUT instantiation
    DUT : test_new port map (sw_tb, btn_tb, clk_tb, cat_tb, an_tb, led_tb);

    -- Clock process
    process
    begin
        while now < 500 ns loop  -- Simulate for 500 ns
            clk_tb <= not clk_tb;
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Apply stimulus here
        -- For example:
        sw_tb <= "0100000000000000";
        btn_tb <= "00100";
        wait for 10 ns;
        
        sw_tb <= "0000000000000000";
        btn_tb <= "01000";
        wait for 10 ns;
        
        btn_tb <= "10000";
        wait for 10 ns;
        
        sw_tb <= "0100000000000000";
        btn_tb <= "00100";
        wait for 10 ns;
        
        sw_tb <= "0000000000000000";
        btn_tb <= "01000";
        
        wait for 100 ns;  -- Allow some time for initialization

        -- Set stimulus_done to true to stop the simulation
        stimulus_done <= true;
        wait;
    end process;

    -- Output monitoring process
    process
    begin
        wait until stimulus_done;

        -- Monitor or check the outputs here
        -- For example:
        assert false
            report "Add your output checks/assertions here"
            severity warning;

        wait;
    end process;

end sim;
