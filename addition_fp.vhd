library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity addition_fp is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
         B : in STD_LOGIC_VECTOR (31 downto 0);
         clk: in std_logic;
         Sum : out STD_LOGIC_VECTOR (31 downto 0);
         Overflow_flag: out std_logic);
end addition_fp;

architecture Behavioral of addition_fp is

    component subtract_8b is
        Port (
            A: in std_logic_vector(7 downto 0);
            B: in std_logic_vector(7 downto 0);
            Sub: out std_logic_vector(7 downto 0);
            Borrow: out std_logic
        );
    end component;

    component carry_lookahead_adder_23b is
        Port ( A: in std_logic_vector(22 downto 0);
             B: in std_logic_vector(22 downto 0);
             Cin: in std_logic;
             Sum: out std_logic_vector(22 downto 0);
             Cout: out std_logic
            );
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

    component shifter_generic is
        generic (
            WIDTH : positive := 23
        );
        Port (
            A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
            DIR : in STD_LOGIC;
            RESULT : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0)
        );
    end component;

    component add_control is
        Port ( expA_in : in STD_LOGIC_VECTOR (7 downto 0);
             expB_in : in STD_LOGIC_VECTOR (7 downto 0);
             mantissaA_in: in std_logic_vector(22 downto 0);
             mantissaB_in: in std_logic_vector(22 downto 0);
             expA_out : out STD_LOGIC_VECTOR (7 downto 0);
             mantissaA_out: out std_logic_vector(22 downto 0);
             expB_out : out STD_LOGIC_VECTOR (7 downto 0);
             mantissaB_out: out std_logic_vector(22 downto 0)
            );
    end component;

    component subtract_23b is
        Port (
            A: in std_logic_vector(22 downto 0);
            B: in std_logic_vector(22 downto 0);
            Sub: out std_logic_vector(22 downto 0);
            Borrow: out std_logic
        );
    end component;

    component normalization_addition is
        Port (
            mantissa_in: in std_logic_vector(22 downto 0);
            exponent_in: in std_logic_vector(7 downto 0);
            clk: in std_logic;
            mantissa_out: out std_logic_vector(22 downto 0);
            exponent_out: out std_logic_vector(7 downto 0)
        );
    end component;

    component add_matissa_unit is
    Port ( signA : in STD_LOGIC;
         signB : in STD_LOGIC;
         mantissaA : in STD_LOGIC_VECTOR (22 downto 0);
         mantissaB : in STD_LOGIC_VECTOR (22 downto 0);
         clk: in std_logic;
         mantissaOut : out STD_LOGIC_VECTOR (22 downto 0);
         signOut: out std_logic;
         overflow: out std_logic);
end component;

    signal A_reg, B_reg: std_logic_vector(31 downto 0);
    signal mantissaA, mantissaB, mantissa: std_logic_vector(22 downto 0);
    signal expA, expB: std_logic_vector(7 downto 0);
    signal coutSum: std_logic;

begin

    regA: register_generic port map (A, '1', '0', clk, A_reg);
    regB: register_generic port map (B, '1', '0', clk, B_reg);

    --subtractExp: subtract_8b port map (A_reg(30 downto 23), B_reg(30 downto 23), diffExp, borrowExp);

    control: add_control port map (A_reg(30 downto 23), B_reg(30 downto 23), A_reg(22 downto 0), B_reg(22 downto 0), expA, mantissaA, expB, mantissaB);

    --    addMantissa: carry_lookahead_adder_23b port map (mantissaA, mantissaB, '0', mantissaSum, coutSum);
    --    subAB: subtract_23b port map (mantissaA, mantissaB, mantissaAB, borrowA);
    --    subBA: subtract_23b port map (mantissaB, mantissaA, mantissaBA, borrowB);

    --    process (A_reg, B_reg)
    --    begin
    --        if A_reg(31) = B_reg(31) then
    --            mantissa <= mantissaSum;
    --            Sum(31) <= A_reg(31);
    --            Overflow_flag <= coutSum;
    --        else
    --            if unsigned(mantissaA) > unsigned(mantissaB) then
    --                mantissa <= mantissaAB;
    --                Sum(31) <= A_reg(31);
    --                Overflow_flag <= borrowA;
    --            else
    --                mantissa <= mantissaBA;
    --                Sum(31) <= B_reg(31);
    --                Overflow_flag <= borrowB;
    --            end if;
    --        end if;
    --    end process;

    addMantissas: add_matissa_unit port map (A_reg(31), B_reg(31), mantissaA, mantissaB, clk, mantissa, Sum(31), Overflow_flag);

    normalization: normalization_addition port map (mantissa, expA, clk, Sum(22 downto 0), Sum(30 downto 23));


end Behavioral;
