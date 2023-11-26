library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_env is
    Port (sw: in std_logic_vector(15 downto 0);
         btn: in std_logic_vector(4 downto 0);
         clk: in std_logic;
         cat: out std_logic_vector(6 downto 0);
         an: out std_logic_vector(3 downto 0);
         led: out std_logic_vector(15 downto 0)
        );
end test_env;

architecture Behavioral of test_env is
    component SSD is
        Port (
            clk : in std_logic;
            digit0 : in std_logic_vector (3 downto 0);
            digit1 : in std_logic_vector (3 downto 0);
            digit2 : in std_logic_vector (3 downto 0);
            digit3 : in std_logic_vector (3 downto 0);
            digit4 : in std_logic_vector (3 downto 0);
            digit5 : in std_logic_vector (3 downto 0);
            digit6 : in std_logic_vector (3 downto 0);
            digit7 : in std_logic_vector (3 downto 0);
            an : out std_logic_vector(3 downto 0);
            cat : out std_logic_vector(6 downto 0)
        );
    end component;

    component SSD2 is
        Port (clk : in std_logic;
             digit0 : in std_logic_vector (3 downto 0);
             digit1 : in std_logic_vector (3 downto 0);
             digit2 : in std_logic_vector (3 downto 0);
             digit3 : in std_logic_vector (3 downto 0);
             an : out std_logic_vector(3 downto 0);
             cat : out std_logic_vector(6 downto 0) );
    end component;

    component MPG is
        Port ( clk : in STD_LOGIC;
             btn : in STD_LOGIC;
             en : out STD_LOGIC);
    end component;

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

    component register_generic is
        generic (
            WIDTH: positive := 32
        );
        Port (
            d : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            ld : in STD_LOGIC;
            clear : in STD_LOGIC;
            clk : in STD_LOGIC;
            q : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0)
        );
    end component;

    signal A_FH, A_SH, B_FH, B_SH: std_logic_vector(15 downto 0);
    signal fh, sh, rst, add, mult, opChosen, loadAF, loadAS, loadBF, loadBS: std_logic:='0';
    signal done: std_logic;
    signal result, sum, product: std_logic_vector(31 downto 0);

begin

    resetB: MPG port map (clk, btn(0), rst);
    --led(5) <= rst;
    plusB: MPG port map (clk, btn(1), add);
    --led(6) <= add;
    firstHalfB: MPG port map (clk, btn(2), fh);
    --led(7) <= fh;
    secondHalfB: MPG port map (clk, btn(3), sh);
    --led(8) <= sh;
    timesB: MPG port map(clk, btn(4), mult);
    --led(9) <= mult;

    --    opChosen <= '1' when (add='1' or mult ='1');
    --    led(0) <= opChosen;
    --    loadAF <= '1' when (fh = '1' and opChosen ='0') else '0';
    --    led(1) <= loadAF;
    --    loadAS<= '1' when (sh = '1' and opChosen ='0') else '0';
    --    led(2) <= loadAS;
    --    loadBF <= '1' when (fh = '1' and opChosen ='1') else '0';
    --    led(3) <= loadBF;
    --    loadBS<= '1' when (sh = '1' and opChosen ='1') else '0';
    --    led(4) <= loadBS;

    process(clk)
    begin
        if rst = '1' then
            opChosen <= '0';
            loadAF <= '0';
            loadAS <= '0';
            loadBF <= '0';
            loadBS <= '0';
            result <= (others => '0');
        end if;

        if add='1' or mult ='1' then
            opChosen <= '1';
        end if;
        if fh = '1' and opChosen ='0' then
            loadAF <= '1';
            else loadAF <= '0';
        end if;
        if sh = '1' and opChosen ='0' then
            loadAS <= '1';
             else loadAS <= '0';
        end if;
        if fh = '1' and opChosen ='1' then
            loadBF <= '1';
             else loadBF <= '0';
        end if;
        if sh = '1' and opChosen ='1' then
            loadBS <= '1';
             else loadBS <= '0';
        end if;
--        led(0) <= opChosen;
--        led(1) <= loadAF;
--        led(2) <= loadAS;
--        led(3) <= loadBF;
--        led(4) <= loadBS;
    end process;

    RegAFH: register_generic
        generic map (WIDTH => 16)
        port map (sw, loadAF, rst, clk, A_FH);

    --led(15) <= '1' when A_FH = "0000000000000000" else '0';
    led <= A_SH; --why is lit up at afh????

    RegASH: register_generic
        generic map (WIDTH => 16)
        port map (sw, loadAS, rst, clk, A_SH);

    RegBFH: register_generic
        generic map (WIDTH => 16)
        port map (sw, loadBF, rst, clk, B_FH);

    RegBSH: register_generic
        generic map (WIDTH => 16)
        port map (sw, loadBS, rst, clk, B_SH);

    additionUnit: addition port map(A_FH&A_SH, B_FH&B_SH, clk, rst, add, done, sum);
    multiplicationUnit: multiplier_behavioral port map (A_FH&A_SH, B_FH&B_SH, clk, product);

    result <= sum when (add = '1' and mult = '0') else product;

    --    SSDUnit: SSD port map (clk, result(3 downto 0), result(7 downto 4), result(11 downto 8), result(15 downto 12), result(19 downto 16), result(23 downto 20), result (27 downto 24),
    --                 result(31 downto 28), an, cat);
    SSDUnit2: SSD2 port map (clk, result(19 downto 16), result(23 downto 20), result (27 downto 24),
                 result(31 downto 28), an, cat);

end Behavioral;