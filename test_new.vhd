library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_new is
    Port (sw: in std_logic_vector(15 downto 0);
         btn: in std_logic_vector(4 downto 0);
         clk: in std_logic;
         cat: out std_logic_vector(6 downto 0);
         an: out std_logic_vector(3 downto 0);
         led: out std_logic_vector(15 downto 0) );
end test_new;

architecture Behavioral of test_new is

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

    signal plus, times, rst, first_half, second_half, enA1, enA2, enB1, enB2, stateAdd: std_logic := '0'; --buttons
    signal sum, product: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
    signal A_fh, B_fh, A_sh, B_sh, to_display: std_logic_vector(15 downto 0) := "0000000000000000";
    signal done: std_logic;

begin

    MPGrst: MPG port map (clk, btn(0), rst);
    MPGplus: MPG port map (clk, btn(1), plus);
    MPGfh: MPG port map (clk, btn(2), first_half);
    MPGsh: MPG port map (clk, btn(3), second_half);
    MPGtimes: MPG port map (clk, btn(4), times);

    regAfh: register_generic generic map (WIDTH => 16)
        port map (sw, enA1, rst, clk, A_fh);
    regAsh: register_generic generic map (WIDTH => 16)
        port map (sw, enA2, rst, clk, A_sh);
    regBfh: register_generic generic map (WIDTH => 16)
        port map (sw, enB1, rst, clk, B_fh);
    regBsh: register_generic generic map (WIDTH => 16)
        port map (sw, enB2, rst, clk, B_sh);

    addUnit: addition port map (A_fh&A_sh, B_fh&B_sh, clk, rst, stateAdd, done, sum);
    multiplicationUnit: multiplier_behavioral port map (A_fh&A_sh, B_fh&B_sh, clk, product);

    SSD2Unit: SSD2 port map (clk, to_display(3 downto 0), to_display(7 downto 4), to_display(11 downto 8), to_display(15 downto 12), an, cat);

    process(clk)
        variable stateMult, opChosen, inputDone: std_logic := '0';
        variable result: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    begin
        if rising_edge(clk) then

            if rst = '1' then
                enA1 <= '0';
                enA2 <= '0';
                enB1 <= '0';
                enB2 <= '0';
                stateAdd <= '0';
                result := "00000000000000000000000000000000";
                sum <= "00000000000000000000000000000000";
                product <= "00000000000000000000000000000000";
                A_fh  <= "0000000000000000";
                B_fh <= "0000000000000000";
                A_sh <= "0000000000000000";
                B_sh <= "0000000000000000";
                to_display <= "0000000000000000";
                stateMult := '0';
                opChosen := '0';
                inputDone := '0';
            end if;

            if first_half = '1' and opChosen = '0' then
                enA1 <= '1';
                else enA1 <= '0';
            end if;
            if second_half = '1' and opChosen = '0' then               
                enA2 <= '1';
                else enA2 <= '0';
            end if;

            if plus = '1' then
                opChosen := '1';
                stateAdd <= '1';
            end if;
            if times = '1' then
                opChosen := '1';
                stateMult := '1';
            end if;

            if first_half = '1' and opChosen = '1' then
                enB1 <= '1';
                else enB1 <= '0';
            end if;
            if second_half = '1' and opChosen = '1' then
                enB2 <= '1';
                inputDone := '1';
                else enB2 <= '0';
            end if;

            if inputDone = '1' then
                if stateAdd = '1' then result := sum;
                else if stateMult = '1' then result := product;
                    end if;
                end if;
                report integer'image(CONV_INTEGER(UNSIGNED(result)));
                to_display <= result(31 downto 16);
            end if;
            
            led(0) <= enA1;
            led(1) <= enA2;
            led(2) <= enB1;
            led(3) <= enB2;

            led(4) <= opChosen;

            led(5) <= stateAdd;
            led(6) <= stateMult;
            
            led(7) <= inputDone;
            if result = "00000000000000000000000000000000" then led(8) <= '1';
            end if;
            if A_fh = "0000000000000000" then led(9) <= '1';
            end if;
            if A_sh = "0000000000000000" then led(10) <= '1';
            end if;
            if B_fh = "0000000000000000" then led(11) <= '1';
            end if;
            if B_sh = "0000000000000000" then led(12) <= '1';
            end if;
            --led(15 downto 8) <= result(31 downto 24);

        end if;
    end process;

end Behavioral;
