library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity multiplier_behavioral is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
         y : in  STD_LOGIC_VECTOR (31 downto 0);
         clk: in std_logic;
         z : out  STD_LOGIC_VECTOR (31 downto 0));
end multiplier_behavioral;

architecture Behavioral of multiplier_behavioral is

begin
    process(clk,x,y)
        variable x_mantissa : STD_LOGIC_VECTOR (22 downto 0);
        variable x_exponent : STD_LOGIC_VECTOR (7 downto 0);
        variable x_sign : STD_LOGIC;
        variable y_mantissa : STD_LOGIC_VECTOR (22 downto 0);
        variable y_exponent : STD_LOGIC_VECTOR (7 downto 0);
        variable y_sign : STD_LOGIC;
        variable z_mantissa : STD_LOGIC_VECTOR (22 downto 0);
        variable z_exponent : STD_LOGIC_VECTOR (7 downto 0);
        variable z_sign : STD_LOGIC;
        variable aux : STD_LOGIC;
        variable aux2 : STD_LOGIC_VECTOR (47 downto 0);
        variable exponent_sum : STD_LOGIC_VECTOR (8 downto 0);
    begin
        if rising_edge(clk) then
            x_mantissa := x(22 downto 0);
            x_exponent := x(30 downto 23);
            x_sign := x(31);
            y_mantissa := y(22 downto 0);
            y_exponent := y(30 downto 23);
            y_sign := y(31);

            -- special cases
            if (x_exponent=255 or y_exponent=255) then
                -- inf*x or x*inf
                z_exponent := "11111111";
                z_mantissa := (others => '0');
                z_sign := x_sign xor y_sign;

            elsif (x_exponent=0 or y_exponent=0) then
                -- 0*x or x*0
                z_exponent := (others => '0');
                z_mantissa := (others => '0');
                z_sign := '0';
            else

                aux2 := ('1' & x_mantissa) * ('1' & y_mantissa);
                if (aux2(47)='1') then
                    -- >=2, shift left and add one to exponent
                    z_mantissa := aux2(46 downto 24) + aux2(23); -- with rounding
                    aux := '1';
                else
                    z_mantissa := aux2(45 downto 23) + aux2(22); -- with rounding
                    aux := '0';
                end if;

                -- calculate exponent
                exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) + aux - 127; --bias

                if (exponent_sum(8)='1') then
                    if (exponent_sum(7)='0') then -- overflow
                        z_exponent := "11111111";
                        z_mantissa := (others => '0');
                        z_sign := x_sign xor y_sign;
                    else 									-- underflow
                        z_exponent := (others => '0');
                        z_mantissa := (others => '0');
                        z_sign := '0';
                    end if;
                else								  		 -- Ok, finish
                    z_exponent := exponent_sum(7 downto 0);
                    z_sign := x_sign xor y_sign;
                end if;
            end if;


            z(22 downto 0) <= z_mantissa;
            z(30 downto 23) <= z_exponent;
            z(31) <= z_sign;
        end if;
    end process;
end Behavioral;