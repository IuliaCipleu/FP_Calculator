--------library IEEE;
--------use IEEE.STD_LOGIC_1164.ALL;
--------use ieee.std_logic_unsigned.all;

--------entity mult_beh_booth is
--------    Port (
--------        x : in STD_LOGIC_VECTOR (31 downto 0);
--------        y : in STD_LOGIC_VECTOR (31 downto 0);
--------        clk: in std_logic;
--------        z : out STD_LOGIC_VECTOR (31 downto 0)
--------    );
--------end mult_beh_booth;

--------architecture Behavioral of mult_beh_booth is
--------    signal product : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
--------    signal shift_count : integer := 0;
--------    signal is_negative : std_logic := '0';

--------begin
--------    process(clk)
--------        variable x_mantissa : STD_LOGIC_VECTOR (22 downto 0);
--------        variable x_exponent : STD_LOGIC_VECTOR (7 downto 0);
--------        variable y_mantissa : STD_LOGIC_VECTOR (22 downto 0);
--------        variable y_exponent : STD_LOGIC_VECTOR (7 downto 0);
--------        variable aux : STD_LOGIC_VECTOR (47 downto 0);
--------        variable exponent_sum : STD_LOGIC_VECTOR (8 downto 0);
--------    begin
--------        if rising_edge(clk) then
--------            x_mantissa := x(22 downto 0);
--------            x_exponent := x(30 downto 23);
--------            y_mantissa := y(22 downto 0);
--------            y_exponent := y(30 downto 23);

--------            is_negative <= x(31) xor y(31);

--------            -- Use Booth's algorithm for multiplication
--------            aux := (others => '0');
--------            for i in 0 to 31 loop
--------                if y(0) = '1' then
--------                    aux := aux + ('0' & x_mantissa);
--------                end if;

--------                -- Perform arithmetic right shift
--------                x_mantissa := '0' & x_mantissa(22 downto 1);
--------                y_exponent := y_exponent - 1;

--------                -- Update product and shift count
--------                product <= ('0' & product(63 downto 1)) + ('0' & aux(47 downto 1));
--------                shift_count <= shift_count + 1;
--------            end loop;

--------            -- calculate exponent
--------            exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) - 127;

--------            if (exponent_sum(8)='1') then
--------                -- overflow or underflow
--------                z <= (others => '0');
--------            else
--------                -- Ok
--------                if is_negative = '0' then
--------                    z <= product(62 downto 31);
--------                else z <= not product(62 downto 31) + "1";
--------                end if;
--------            end if;
--------        end if;
--------    end process;
--------end Behavioral;
------library IEEE;
------use IEEE.STD_LOGIC_1164.ALL;
------use ieee.std_logic_unsigned.all;

------entity mult_beh_booth is
------    Port (
------        x : in STD_LOGIC_VECTOR (31 downto 0);
------        y : in STD_LOGIC_VECTOR (31 downto 0);
------        clk: in std_logic;
------        z : out STD_LOGIC_VECTOR (31 downto 0)
------    );
------end mult_beh_booth;

------architecture Behavioral of mult_beh_booth is
------    signal is_negative : std_logic := '0';

------    -- Booth multiplier instance
------    entity booth_multiplier_behavioral is
------        generic (
------            x : INTEGER := 32;
------            y : INTEGER := 32
------        );
------        port (
------            m : in STD_LOGIC_VECTOR(x - 1 downto 0);
------            r : in STD_LOGIC_VECTOR(y - 1 downto 0);
------            result : out STD_LOGIC_VECTOR(x + y - 1 downto 0)
------        );
------    end entity;

------    architecture behavior of booth_multiplier_behavioral is
------    begin
------        process(m, r)
------            constant X_ZEROS : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
------            constant Y_ZEROS : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
------            variable a, s, p : STD_LOGIC_VECTOR(63 downto 0);
------            variable mn : STD_LOGIC_VECTOR(31 downto 0);
------        begin
------            a := (others => '0');
------            s := (others => '0');
------            p := (others => '0');

------            if (m /= X_ZEROS AND r /= Y_ZEROS) then
------                a(63 downto 33) := (others => '0');
------                a(32 downto 1) := m;
------                a(0) := m(31);

------                mn := (not m) + "1";

------                s(63 downto 33) := (others => '0');
------                s(32 downto 1) := mn;
------                s(0) := not m(31);

------                p(31 downto 1) := r;
------                p(0) := '0';

------                for i in 1 to 32 loop
------                    if p(1 downto 0) = "01" then
------                        p := p + a;
------                    elsif p(1 downto 0) = "10" then
------                        p := p + s;
------                    end if;

------                    p(63 downto 1) := p(63 downto 2);
------                    p(0) := '0';
------                end loop;
------            end if;

------            result <= p(63 downto 32);
------        end process;
------    end architecture;

------begin
------    process(clk)
------        variable x_mantissa : STD_LOGIC_VECTOR (22 downto 0);
------        variable x_exponent : STD_LOGIC_VECTOR (7 downto 0);
------        variable y_mantissa : STD_LOGIC_VECTOR (22 downto 0);
------        variable y_exponent : STD_LOGIC_VECTOR (7 downto 0);
------        variable aux : STD_LOGIC_VECTOR (47 downto 0);
------        variable exponent_sum : STD_LOGIC_VECTOR (8 downto 0);
------        variable booth_result : STD_LOGIC_VECTOR (63 downto 0);
------    begin
------        if rising_edge(clk) then
------            x_mantissa := x(22 downto 0);
------            x_exponent := x(30 downto 23);
------            y_mantissa := y(22 downto 0);
------            y_exponent := y(30 downto 23);

------            is_negative <= x(31) xor y(31);

------            -- Use Booth multiplier instance
------            booth_multiplier_instance: booth_multiplier_behavioral
------                generic map (
------                    x => 32,
------                    y => 32
------                )
------                port map (
------                    m => x_mantissa,
------                    r => y_mantissa,
------                    result => booth_result
------                );

------            -- calculate exponent
------            exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) - 127;

------            if (exponent_sum(8)='1') then
------                -- overflow or underflow
------                z <= (others => '0');
------            else
------                -- Ok
------                if is_negative = '0' then
------                    z <= booth_result(62 downto 31);
------                else z <= not booth_result(62 downto 31) + "1";
------                end if;
------            end if;
------        end if;
------    end process;
------end Behavioral;
----library IEEE;
----use IEEE.STD_LOGIC_1164.ALL;
----use ieee.std_logic_unsigned.all;

----entity mult_beh_booth is
----    Port (
----        x : in STD_LOGIC_VECTOR (31 downto 0);
----        y : in STD_LOGIC_VECTOR (31 downto 0);
----        clk: in std_logic;
----        z : out STD_LOGIC_VECTOR (31 downto 0)
----    );
----end mult_beh_booth;

----architecture Behavioral of mult_beh_booth is
----    signal is_negative : std_logic := '0';
----    signal booth_result : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');

----    component booth_multiplier_behavioral IS

----	GENERIC (x : INTEGER := 8;
----		 y : INTEGER := 8);

----	PORT(m : IN STD_LOGIC_VECTOR(x - 1 DOWNTO 0);
----	     r : IN STD_LOGIC_VECTOR(y - 1 DOWNTO 0);
----	     result : OUT STD_LOGIC_VECTOR(x + y - 1 DOWNTO 0));

----END component;

----begin
----    process(clk)
----        variable x_mantissa : STD_LOGIC_VECTOR (22 downto 0);
----        variable x_exponent : STD_LOGIC_VECTOR (7 downto 0);
----        variable y_mantissa : STD_LOGIC_VECTOR (22 downto 0);
----        variable y_exponent : STD_LOGIC_VECTOR (7 downto 0);
----        variable aux : STD_LOGIC_VECTOR (47 downto 0);
----        variable exponent_sum : STD_LOGIC_VECTOR (8 downto 0);
----    begin
----        if rising_edge(clk) then
----            x_mantissa := x(22 downto 0);
----            x_exponent := x(30 downto 23);
----            y_mantissa := y(22 downto 0);
----            y_exponent := y(30 downto 23);

----            is_negative <= x(31) xor y(31);

----            -- Use Booth multiplier instance
----            if (x /= (others => '0') and y /= (others => '0')) then
----                booth_multiplier_instance: booth_multiplier_behavioral
----                    generic map (
----                        x => 32,
----                        y => 32
----                    )
----                    port map (
----                        m => x_mantissa,
----                        r => y_mantissa,
----                        result => booth_result
----                    );
----            else
----                booth_result <= (others => '0');
----            end if;

----            -- calculate exponent
----            exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) - 127;

----            if (exponent_sum(8)='1') then
----                -- overflow or underflow
----                z <= (others => '0');
----            else
----                -- Ok
----                if is_negative = '0' then
----                    z <= booth_result(62 downto 31);
----                else z <= not booth_result(62 downto 31) + "1";
----                end if;
----            end if;
----        end if;
----    end process;
----end Behavioral;
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_unsigned.all;

--entity mult_beh_booth is
--    Port (
--        x : in STD_LOGIC_VECTOR (31 downto 0);
--        y : in STD_LOGIC_VECTOR (31 downto 0);
--        clk: in std_logic;
--        z : out STD_LOGIC_VECTOR (31 downto 0)
--    );
--end mult_beh_booth;

--architecture Behavioral of mult_beh_booth is
--    signal is_negative : std_logic := '0';
--    signal booth_result, booth_result_outside : STD_LOGIC_VECTOR (47 downto 0) := (others => '0');

--    component booth_multiplier_behavioral
--        GENERIC (
--            x : INTEGER := 8;
--            y : INTEGER := 8
--        );
--        PORT (
--            m : IN STD_LOGIC_VECTOR(x - 1 DOWNTO 0);
--            r : IN STD_LOGIC_VECTOR(y - 1 DOWNTO 0);
--            result : OUT STD_LOGIC_VECTOR(x + y - 1 DOWNTO 0)
--        );
--    end component;

--begin
--    booth_multiplier_instance: booth_multiplier_behavioral
--                    generic map (
--                        x => 24,
--                        y => 24
--                    )
--                    port map (
--                        m => '1' & x(22 downto 0),
--                        r => '1' & y(22 downto 0),
--                        result => booth_result_outside
--                    );
--    process(clk)
--        variable x_mantissa : STD_LOGIC_VECTOR (22 downto 0);
--        variable x_exponent : STD_LOGIC_VECTOR (7 downto 0);
--        variable y_mantissa : STD_LOGIC_VECTOR (22 downto 0);
--        variable y_exponent : STD_LOGIC_VECTOR (7 downto 0);
--        variable aux : STD_LOGIC_VECTOR (47 downto 0);
--        variable exponent_sum : STD_LOGIC_VECTOR (8 downto 0);
--    begin
--        if rising_edge(clk) then
--            x_mantissa := x(22 downto 0);
--            x_exponent := x(30 downto 23);
--            y_mantissa := y(22 downto 0);
--            y_exponent := y(30 downto 23);

--            is_negative <= x(31) xor y(31);

--            -- Use Booth multiplier instance
--            if (x /= "00000000000000000000000000000000" and y /= "00000000000000000000000000000000") then
--                booth_result <= booth_result_outside;
--            else
--                booth_result <= (others => '0');
--            end if;

--            if (booth_result(47)='1') then
--                    -- >=2, shift left and add one to exponent
--                    z_mantissa := booth_result(46 downto 24) + booth_result(23); -- with rounding
--                    aux := '1';
--                else
--                    z_mantissa := booth_result(45 downto 23) + booth_result(22); -- with rounding
--                    aux := '0';
--                end if;

--            -- calculate exponent
--            exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) - 127;

--            if (exponent_sum(8)='1') then
--                -- overflow or underflow
--                z <= (others => '0');
--            else
--                -- Ok
--                if is_negative = '0' then
--                    z <= booth_result(45 downto 14);
--                else z <= not booth_result(45 downto 14) + "1";
--                end if;
--            end if;
--        end if;
--    end process;
--end Behavioral;
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
    component booth_multiplier_behavioral
        GENERIC (
            x : INTEGER := 8;
            y : INTEGER := 8
        );
        PORT (
            m : IN STD_LOGIC_VECTOR(x - 1 DOWNTO 0);
            r : IN STD_LOGIC_VECTOR(y - 1 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(x + y - 1 DOWNTO 0)
        );
    end component;
    signal booth_result_outside: std_logic_vector(47 downto 0);
begin

    booth_multiplier_instance: booth_multiplier_behavioral
        generic map (
            x => 24,
            y => 24
        )
        port map (
            m => '1' & x(22 downto 0),
            r => '1' & y(22 downto 0),
            result => booth_result_outside
        );

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

            -- inf*0 is not tested (result would be NaN)
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

                --aux2 := ('1' & x_mantissa) * ('1' & y_mantissa);
                aux2 := booth_result_outside;
                if (aux2(47)='1') then
                    -- >=2, shift left and add one to exponent
                    z_mantissa := aux2(46 downto 24) + aux2(23); -- with rounding
                    aux := '1';
                else
                    z_mantissa := aux2(45 downto 23) + aux2(22); -- with rounding
                    aux := '0';
                end if;

                -- calculate exponent
                exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) + aux - 127;

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
                else								  		 -- Ok
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