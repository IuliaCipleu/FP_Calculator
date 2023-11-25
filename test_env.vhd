library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL; -- Add this line for text I/O

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

    --file result_file : TEXT open WRITE_MODE is "result.txt";

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

    signal A_FH, A_SH, B_FH, B_SH, to_display: std_logic_vector(15 downto 0);
    signal fh, sh, rst, add, mult, opChosen, loadAF, loadAS, loadBF, loadBS: std_logic:='0';
    signal done: std_logic;
    signal result, sum, product: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";

begin

    equalB: MPG port map (clk, btn(0), rst);

    plusB: MPG port map (clk, btn(1), add);

    firstHalfB: MPG port map (clk, btn(2), fh);

    secondHalfB: MPG port map (clk, btn(3), sh);

    timesB: MPG port map(clk, btn(4), mult);


    process(clk)
        variable fhState1, shState1, fhState2, shState2, rstState, addState, multState, inputDone: std_logic:='0';
        variable count_fh, count_sh :integer:= 0;
    begin --buttons stay 1 just when pressed, so maybe i need some signals to check if those buttons were pressed at a moments, sometime
        if rising_edge(clk) then
            led(5) <= rst;
            led(6) <= addState;
            led(7) <= fhState1;
            led(8) <= shState2;
            led(9) <= multState;
            led(10) <= inputDone;
            led(11) <= fhState2;
            led(12) <= shState1;
            if rst = '1' then
                fhState1 := '0';
                shState1 := '0';
                fhState2 := '0';
                shState2 := '0';
                rstState := '0';
                addState := '0';
                multState := '0';
                count_fh := 0;
                count_sh := 0;
                opChosen <= '0';
                loadAF <= '0';
                loadAS <= '0';
                loadBF <= '0';
                loadBS <= '0';
                inputDone := '0';
                result <= (others => '0');
                to_display <= (others => '0');
            end if;
            if (add = '1') then
                addState := '1';
            end if;
            if (mult = '1') then
                multState := '1';
            end if;
            if fh = '1' and fhState1 = '0' and opChosen = '0' then
                fhState1 := '1';
                --to_display <= A_FH;
            end if;
            if fh = '1' and fhState1 = '1'and opChosen = '1' then
                fhState2 := '1';
            end if;
            if sh = '1' and shState1 = '0' and opChosen = '0' then
                shState1 := '1';
            end if;
            if sh = '1' and shState1 = '1' and  opChosen = '1' then
                shState2 := '1';
            end if;
            if (add = '1' or mult = '1') then
                opChosen <= '1';
            end if;
            led(0) <= opChosen;
            if (fh = '1' and opChosen ='0') then
                loadAF <= '1';
            else loadAF <= '0';
            end if;
            led(1) <= loadAF;
            if (sh = '1' and opChosen ='0') then
                loadAS<= '1';
            else loadAS<= '0';
            end if;
            led(2) <= loadAS;
            if (fh = '1' and opChosen ='1') then
                loadBF <= '1';
            else loadBF <='0';
            end if;
            led(3) <= loadBF;
            if (sh = '1' and opChosen ='1') then
                loadBS<= '1';
            else loadBS<='0';
            end if;
            if (loadBS = '1') then
                inputDone := '1';
            end if;
            led(4) <= loadBS;
            if inputDone = '1'  then
                if (addState = '1' and multState = '0') then
                    result <= sum;
                end if;
                if (addState = '0' and multState = '1') then
                    result <= product;
                end if;
                --report "Value of result: " & integer'image(to_integer(unsigned(result)));
                --                file results : text open write_mode is "C:\Users\Cipleu\Documents\IULIA\SCOALA\facultate\Year 3 Semester 1\SCS\Lab\project\alu_fp_4\results.txt";
                --                write(result_line, string'("Result: " & to_string(result)));
                --                writeline(result_file, result_line);
                --                file_close(results);
                to_display <= result(31 downto 16);
                --else to_display <= result(15 downto 0);
            end if;
            --            if eq = '1' then 
            --            else 
            --            end if; --that was for press eq to show second half of result
        end if;
    end process;
    RegAFH: register_generic
        generic map (WIDTH => 16)
        port map (sw, loadAF, rst, clk, A_FH);

    RegASH: register_generic
        generic map (WIDTH => 16)
        port map (sw, loadAS, rst, clk, A_SH);

    RegBFH: register_generic
        generic map (WIDTH => 16)
        port map (sw, loadBF, rst, clk, B_FH);

    RegBSH: register_generic
        generic map (WIDTH => 16)
        port map (sw, loadBS, rst, clk, B_SH);

    additionUnit: addition port map(A_FH&A_SH, B_FH&B_SH, clk, rst, '1', done, sum); --'1'instead of add???
    multiplicationUnit: multiplier_behavioral port map (A_FH&A_SH, B_FH&B_SH, clk, product);



    --    SSDUnit: SSD port map (clk, result(3 downto 0), result(7 downto 4), result(11 downto 8), result(15 downto 12), result(19 downto 16), result(23 downto 20), result (27 downto 24),
    --                 result(31 downto 28), an, cat);

    SSD2Unit: SSD2 port map (clk, to_display(3 downto 0), to_display(7 downto 4), to_display(11 downto 8), to_display(15 downto 12), an, cat);

end Behavioral;
