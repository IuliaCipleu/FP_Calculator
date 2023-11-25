library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity normalization_unit is
    Port (mantissa_in: in std_logic_vector(47 downto 0);
         exponent_in: in std_logic_vector(7 downto 0);
         clk: in std_logic;
         --en: in std_logic;
         mantissa_out: out std_logic_vector(22 downto 0);
         exponent_out: out std_logic_vector(7 downto 0));
         --done: out std_logic);
end normalization_unit;

architecture Behavioral of normalization_unit is

--    component shifter_generic is
--        generic (
--            WIDTH : positive := 23
--        );
--        Port (
--            A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
--            DIR : in STD_LOGIC;
--            RESULT : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0)
--        );
--    end component;

    signal mantissa: std_logic_vector(22 downto 0);
    signal exponent: std_logic_vector (7 downto 0);
    signal enable: std_logic;

begin

    --    process(mantissa_in, exponent_in)
    --    begin
    --        if mantissa_in = "00000000000000000000000" then
    --            mantissa_out <= (others => '0');
    --            exponent_out <= exponent_in;
    --        else
    --            if mantissa_in(22) = '0' then
    --                mantissa <= mantissa_in(21 downto 0) & '0';
    --                exponent <= exponent_in - "00000001";
    --                mantissa_out <= mantissa;
    --                exponent_out <= exponent;
    --            else
    --                mantissa_out <= mantissa_in;
    --                exponent_out <= exponent_in;
    --            end if;
    --        end if;
    --    end process;
    --enable <= en;
--    process (clk, mantissa_in, exponent_in, en)
--    begin
--        enable <= en; 
--        if rising_edge(clk) then
--            if mantissa_in = "00000000000000000000000" or en = '0'then
--                enable <= '0';
--                mantissa <= mantissa_in;
--                exponent <= exponent_in;
--            else
--                if enable = '1' then
--                    --shift: shifter_generic port map (mantissa_in, '0', mantissa_out);
--                    mantissa <= mantissa_in(21 downto 0) & '0';
--                    exponent <= exponent_in - "00000001";
--                    --done <= '0';
--                    if mantissa(22) = '1' then
--                    --this is not a loop
--                        enable <= '0';
--                        --mantissa <= mantissa_in;
--                        --exponent <= exponent_in;
--                        --done <= '1'; --worse with done
--                    else 
--                        enable <= '1';
--                        --mantissa <= mantissa_in;
--                        --exponent <= exponent_in;
--                    end if;
--                end if;
--            end if;
--        end if;
--    end process;
    
--    mantissa_out <= mantissa;
--    exponent_out <= exponent;

    process(clk, mantissa_in, exponent_in)
    begin
        if rising_edge(clk) then
            if mantissa_in(47) = '1' then
                enable <= '0' ;
                mantissa <= mantissa_in(46 downto 24) + mantissa_in(23); --45:24
                exponent <= exponent_in + "00000001";
            else 
                if mantissa_in = "00000000000000000000000" then
                    mantissa <= "00000000000000000000000";
                    exponent <= exponent_in;
                else 
                    mantissa <= mantissa_in(45 downto 23) + mantissa_in(22); --46:23
                    exponent <= exponent_in; 
                end if;
            end if;
        end if;
    end process;
    
    mantissa_out <= mantissa;
    exponent_out <= exponent;

end Behavioral;