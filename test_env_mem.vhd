library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity test_env_mem is
    Port (sw: in std_logic_vector(15 downto 0);
         btn: in std_logic_vector(4 downto 0);
         clk: in std_logic;
         cat: out std_logic_vector(6 downto 0);
         an: out std_logic_vector(3 downto 0);
         led: out std_logic_vector(15 downto 0)
        );
end test_env_mem;

architecture Behavioral of test_env_mem is

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

    type mem_list is array (0 to 63) of std_logic_vector(31 downto 0);
    signal A_op: mem_list := (
        "00000000000000000000000000000000",
        "01000000011000000000000000000000",
        "10111111110100000000000000000000",
        "11000010110100000000100000000000",
        "01000001101011100000000000000000",
        "01000000000000000000000000000000",
        "11111111111111111111111111111111",
        "01000100001000010111011100001010",
        "01000011111100010101111101101000",
        "11000111100001111001100110100011",
        "01000010011000010101000111101100",
        others => "00000000000000000000000000000000"
    );
    signal B_op: mem_list := (
        "00000000000000000000000000000000",
        "01000000110110000000000000000000",
        "01000001000100010000000000000000",
        "11000000101100000000000000000000",
        "11000001000010000000000000000000",
        "01000000000000000000000000000000",
        "11111111111111111111111111111111",
        "01000100011110110110100001010010",
        "11000011101110110000010111101111",
        "11001001011001100110011011001111",
        "11000011101101100101010001111011",
        others => "00000000000000000000000000000000"
    );

    signal index: integer range -1 to 64 := 0;
    signal nextAddress, reset, done, lastValue: std_logic :='0';
    signal A, B, sum, product, result: std_logic_vector(31 downto 0) := (others => '0');
    signal toDisplay: std_logic_vector(15 downto 0) := (others => '0');
    signal count: std_logic_vector(5 downto 0):="000000";
    type state_type is (IDLE, INPUT_OPERANDS, CHOOSE_OPERATION, DISPLAY_RESULT);
    signal state : state_type := IDLE;
begin

    MPG_RESET: MPG port map (clk, btn(0), reset);
    --MPG_NEXT_ADDRESS: MPG port map (clk, btn(1), nextAddress);

    --    process(clk, reset)
    --    begin
    --        if reset = '1' then
    --            -- Reset logic
    --            state <= IDLE;
    --            index <= 0;
    --            toDisplay <= (others => '0');
    --        elsif rising_edge(clk) then
    --            -- State machine logic
    --            case state is
    --                when IDLE =>
    --                    -- Transition conditions for IDLE state
    --                    if nextAddress = '1' then
    --                        state <= INPUT_OPERANDS;
    --                    end if;
    --                when INPUT_OPERANDS =>
    --                    -- Transition conditions for INPUT_OPERANDS state
    --                    if index = 63 then
    --                        state <= CHOOSE_OPERATION;
    --                    else
    --                        index <= index + 1;
    --                    end if;
    --                when CHOOSE_OPERATION =>
    --                    if sw(0) = '0' then
    --                        result <= sum;
    --                    else 
    --                        result <= product;
    --                    end if;
    --                when others =>
    --                    if sw(1) = '0' then 
    --                        toDisplay <= result(15 downto 0);
    --                    else 
    --                        toDisplay <= result(31 downto 16);
    --                    end if;
    --            end case;
    --        end if;
    --    end process;

    --    process(clk, reset)
    --    begin
    --        if reset = '1' then
    --            index <= 0;
    --            toDisplay <= (others => '0');
    --        elsif rising_edge(clk) then
    --            if nextAddress = '1' then
    --                if index = 63 then
    --                    index <= 0;
    --                else
    --                    index <= index + 1;
    --                end if;
    --            end if;
    --        end if;
    --    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                index <= 0;
                toDisplay <= (others => '0');
                count <= "000000";
            else
                if sw(15) /= lastValue then
                    nextAddress <= '1';
                    if index = 63 then
                        index <= 0;
                    else
                        index <= index + 1;
                        count <= count + "000001";
                    end if;
                    lastValue <= sw(15);
                else
                    nextAddress <= '0';
                end if;
            end if;
        end if;
    end process;


    --index <= index + 1 when (nextAddress = '1' and index < 63) else 0 when (reset = '1' or (nextAddress = '1' and index >= 63));

    --    process(clk)
    --    begin
    --        if rising_edge(clk) then
    --            if reset = '1' then
    --                index <= 0;
    --                toDisplay <= (others => '0');
    --                count <= "000000";
    --            else
    --                if nextAddress = '1' then
    --                    index <= index + 1;
    --                end if;
    --            end if;
    --        end if;
    --    end process;

    RegA: register_generic port map (A_op(index), nextAddress, reset, clk, A);
    RegB: register_generic port map (B_op(index), nextAddress, reset, clk, B);

    addition_unit: addition port map (A, B, clk, reset, '1', done, sum);
    multiplication_unit: multiplier_behavioral port map (A_op(index), B_op(index), clk, product);

    result <= sum when sw(0) = '0' else product;
    led(0) <= '1' when result = "00000000000000000000000000000000" else '0'; --zero flag
    led(1) <= '1' when index = 0 else '1';
    led(2) <= '1' when count = "000000" else '1';

    toDisplay <= result(31 downto 16) when sw(1) = '0' else result(15 downto 0);

    SSD: SSD2 port map (clk, toDisplay(3 downto 0), toDisplay(7 downto 4), toDisplay(11 downto 8), toDisplay(15 downto 12), an, cat);

end Behavioral;
