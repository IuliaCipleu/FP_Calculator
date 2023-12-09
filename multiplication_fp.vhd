library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.constants.all;
use IEEE.std_logic_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplication_fp is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
         B : in STD_LOGIC_VECTOR (31 downto 0);
         Product : out STD_LOGIC_VECTOR (31 downto 0);
         overflow_flag: out std_logic;
         clk: in std_logic);
end multiplication_fp;
architecture Behavioral of multiplication_fp is
    signal A_reg, B_reg: std_logic_vector(31 downto 0):=(others=>'0');
    signal A_mantissa, B_mantissa, mantissa_normalized, mantissa_normalized2 : STD_LOGIC_VECTOR(22 downto 0):=(others => '0');
    signal  P_mantissa, P_mantissa_2complement, P_mantissa_2complement2, shifted : STD_LOGIC_VECTOR(47 downto 0):=(others => '0');
    signal A_exponent, B_exponent, S1_exponent, S2_exponent, S3_exponent, F_exponent, exponent_normalized, exponent_normalized2 : STD_LOGIC_VECTOR(7 downto 0):=(others => '0');
    signal C_A, C_B, C_S, C_F, roundBit, nonZero : STD_LOGIC:='0';
    signal A_mantissa_2compl, B_mantissa_2compl : std_logic_vector(23 downto 0);

    component booth_mul is
        generic (NBIT: integer:=24);
        port (a: in std_logic_vector(NBIT-1 downto 0);
             b: in std_logic_vector(NBIT-1 downto 0);
             p: out std_logic_vector(2*NBIT-1 downto 0));
    end component;

    component carry_lookahead_adder_8b is
        Port ( A: in std_logic_vector(7 downto 0);
             B: in std_logic_vector(7 downto 0);
             Cin: in std_logic;
             Sum: out std_logic_vector(7 downto 0);
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

    component subtract_8b is
        Port (
            A: in std_logic_vector(7 downto 0);
            B: in std_logic_vector(7 downto 0);
            Sub: out std_logic_vector(7 downto 0);
            Borrow: out std_logic
        );
    end component;

    component normalization_unit is
        Port (mantissa_in: in std_logic_vector(47 downto 0);
             exponent_in: in std_logic_vector(7 downto 0);
             clk: in std_logic;
             --en: in std_logic;
             mantissa_out: out std_logic_vector(22 downto 0);
             exponent_out: out std_logic_vector(7 downto 0));
        --done: out std_logic);
    end component;

    component rounding_unit is
        Port (
            mantissa_in: in std_logic_vector(22 downto 0);
            round: in std_logic;
            mantissa_out: out std_logic_vector(22 downto 0)
        );
    end component;

    component TwosComplementToBinary is
        Port (
            twosComplementInput : in STD_LOGIC_VECTOR(47 downto 0);
            binaryOutput : out STD_LOGIC_VECTOR(47 downto 0)
        );
    end component;

    component conv_2_complement is
        generic (
            WIDTH: positive := 8
        );
        Port (
            A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
            A_converted : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0)
        );
    end component;

    component MantissaNormalizationUnit is
    Port (
        mantissa_product: in STD_LOGIC_VECTOR(47 downto 0);
        exponent_product: in STD_LOGIC_VECTOR(7 downto 0);
        clk: in std_logic;
        mantissa_normalized: out STD_LOGIC_VECTOR(22 downto 0);
        exponent_normalized: out STD_LOGIC_VECTOR(7 downto 0)
    );
end component;


begin
    regA: register_generic port map (A, '1', '0', clk, A_reg);
    regB: register_generic port map (B, '1', '0', clk, B_reg);
    A_mantissa <= A_reg(22 downto 0);
    B_mantissa <= B_reg(22 downto 0);

    binary_2complA: conv_2_complement generic map (WIDTH => 24)
        port map ('1' & A_mantissa, A_mantissa_2compl);

    binary_2complB: conv_2_complement generic map (WIDTH => 24)
        port map ('1' & B_mantissa, B_mantissa_2compl);

    multiplier_instance : booth_mul
        port map (
            a =>  A_mantissa_2compl,
            b =>  B_mantissa_2compl,
            p => P_mantissa_2complement
        );

    twoscompl_to_binary: TwosComplementToBinary
        port map (
            twosComplementInput => P_mantissa_2complement,
            binaryOutput => P_mantissa
        );

    twoscompl_to_binary2: TwosComplementToBinary
        port map (
            twosComplementInput => P_mantissa,
            binaryOutput => P_mantissa_2complement2
        );


    A_exponent <= A_reg(30 downto 23);
    B_exponent <= B_reg(30 downto 23);
    --S_exponent <= (others => '0');
    --F_exponent <= (others => '0');

    --    A_biasing : subtract_8b
    --        port map (
    --            a => A_exponent,
    --            b => "01111111",
    --            Sub => S1_exponent,
    --            Borrow => C_A
    --        );

    --    B_biasing : subtract_8b
    --        port map (
    --            a => B_exponent,
    --            b => "01111111",
    --            Sub => S2_exponent,
    --            Borrow => C_B
    --        );

    Exp_adder: carry_lookahead_adder_8b
        port map (
            a => A_exponent,
            b => B_exponent,
            cin => '0',
            sum => S3_exponent,
            cout => C_S
        );

    Final_adder : subtract_8b
        port map (
            a => S3_exponent,
            b => "01111111",
            Sub => F_exponent,
            Borrow => C_F
        );

    --    process(clk)
    --    begin
    --        --normalize mantissa
    --        if P_mantissa(45) = '1' then
    --            shifted <= '0' & P_mantissa(45 downto 1);
    --            F_exponent <= F_exponent + "00000001";
    --            P_mantissa <= shifted;
    --        end if;
    --    end process;
    --try in a component

    --norm: normalization_unit port map (P_mantissa(45 downto 23), F_exponent, clk, not P_mantissa(45), mantissa_normalized, Product(30 downto 23));
    --norm: normalization_unit port map (P_mantissa, F_exponent, clk, mantissa_normalized, Product(30 downto 23));
    norm: normalization_unit port map
(P_mantissa_2complement, F_exponent, clk, mantissa_normalized, exponent_normalized);

    norm2: MantissaNormalizationUnit port map (P_mantissa, F_exponent, clk, mantissa_normalized2, exponent_normalized2);

    --    nonZero <= '1' when P_mantissa(24 downto 45) /= "0000000000000000000000000" else '0';
    --    roundBit <= P_mantissa(23) and nonZero;
    --    rounding: rounding_unit
    --        port map (
    --            mantissa_in => mantissa_normalized,
    --            round => roundBit,
    --            mantissa_out => Product(22 downto 0)
    --        );

    Product(30 downto 23) <= exponent_normalized;
    --Product(22 downto 0) <= mantissa_normalized2;
    Product(22 downto 0) <= mantissa_normalized;
    Product(31) <= A_reg(31) XOR B_reg(31);
    overflow_flag <= C_F;

end Behavioral;
