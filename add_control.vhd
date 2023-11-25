library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity add_control is
    Port ( expA_in : in STD_LOGIC_VECTOR (7 downto 0);
         expB_in : in STD_LOGIC_VECTOR (7 downto 0);
         mantissaA_in: in std_logic_vector(22 downto 0);
         mantissaB_in: in std_logic_vector(22 downto 0);
         expA_out : out STD_LOGIC_VECTOR (7 downto 0);
         mantissaA_out: out std_logic_vector(22 downto 0);
         expB_out : out STD_LOGIC_VECTOR (7 downto 0);
         mantissaB_out: out std_logic_vector(22 downto 0)
        );
end add_control;

architecture Behavioral of add_control is
    component subtract_8b is
        Port (
            A: in std_logic_vector(7 downto 0);
            B: in std_logic_vector(7 downto 0);
            Sub: out std_logic_vector(7 downto 0);
            Borrow: out std_logic
        );
    end component;

    component carry_lookahead_adder_23b
        Port ( A : in std_logic_vector(22 downto 0);
             B : in std_logic_vector(22 downto 0);
             Cin : in std_logic;
             Sum : out std_logic_vector(22 downto 0);
             Cout : out std_logic
            );
    end component;

    component GenericShifter is
        generic (
            DATA_WIDTH   : integer := 8;     -- Width of the data to be shifted
            SHIFT_AMOUNT : integer := 1;     -- Number of positions to shift
            LEFT_SHIFT   : boolean := true   -- Direction of shifting (true for left, false for right)
        );
        Port (
            data_in   : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
            data_out  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
        );
    end component;

    signal expAB, expBA: std_logic_vector(7 downto 0);
    signal borrowA, borrowB: std_logic;
    signal mantissaA_shifted, mantissaB_shifted: std_logic_vector(22 downto 0);
begin

    diffAB: subtract_8b port map (expA_in, expB_in, expAB, borrowA);
    diffBA: subtract_8b port map (expB_in, expA_in, expBA, borrowB);
    --case1add_mantissas: carry_lookahead_adder_23b port map (mantissaA_in, mantissaB_in, '0', mantissaSum, cout);
    shiftA: GenericShifter generic map (23, to_integer(unsigned(expBA)), false)
        port map (mantissaA_in, mantissaA_shifted);
    shiftB: GenericShifter generic map (23, to_integer(unsigned(expAB)), false)
        port map (mantissaB_in, mantissaB_shifted);

    process(expA_in, expB_in, mantissaA_in, mantissaB_in)
    begin
        --if expAB = "0000000" then
        if expA_in = expB_in then
            mantissaA_out <= mantissaA_in;
            expA_out <= expA_in;
            mantissaB_out <= mantissaB_in;
            expB_out <= expB_in;
        else
            --if expAB > "0000000" and expAB >= "00010111" then
            if to_integer(unsigned(expAB)) > 0 and to_integer(unsigned(expAB)) >= 23 then
                --shift b expAB times, adj exp b
                mantissaB_out <= mantissaB_shifted;
                expB_out <= std_logic_vector(unsigned(expB_in) - 1);
                mantissaA_out <= mantissaA_in;
                expA_out <= expA_in;
            end if;
            --if expAB > "0000000" and expAB < "00010111" then
            if to_integer(unsigned(expAB)) > 0 and to_integer(unsigned(expAB)) < 23 then
                mantissaA_out <= mantissaA_in;
                expA_out <= expA_in;
                mantissaB_out <= "00000000000000000000000";
                expB_out <= "00000000";
            end if;
            --if expBA > "0000000" and expBA >= "00010111" then
            if to_integer(unsigned(expBA)) > 0 and to_integer(unsigned(expBA)) >= 23 then
                --shift a expBa times, adj exp a
                mantissaA_out <= mantissaA_shifted;
                expA_out <= std_logic_vector(unsigned(expA_in) - 1);
                mantissaB_out <= mantissaB_in;
                expB_out <= expB_in;
            end if;
            --if expBA > "0000000" and expBA < "00010111" then
            if to_integer(unsigned(expBA)) > 0 and to_integer(unsigned(expBA)) < 23 then
                mantissaB_out <= mantissaB_in;
                expB_out <= expB_in;
                mantissaA_out <= "00000000000000000000000";
                expA_out <= "00000000";
            end if;
        end if;
    end process;

end Behavioral;
