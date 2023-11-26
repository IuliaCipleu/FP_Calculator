library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity addition is
    port(A: in  std_logic_vector(31 downto 0);
         B: in  std_logic_vector(31 downto 0);
         clk: in  std_logic;
         reset: in  std_logic;
         start: in  std_logic;
         done: out std_logic;
         RESULT: out std_logic_vector(31 downto 0)
        );
end addition;

architecture Behavioral of addition is
    type LIST_STATES is (WAIT_STATE, ALIGN_STATE, ADD_STATE, NORM_STATE, OUT_STATE);
    signal state : LIST_STATES := WAIT_STATE; -- the machine waits for a signal, it shouldn't start automatically
    signal A_mantissa, B_mantissa, RESULT_mantissa: std_logic_vector (24 downto 0); --mantissa 23 bits, but we need extra 1 for carry, extra 1 for hidden bit
    signal A_exponent, B_exponent, RESULT_exponent: std_logic_vector (8 downto 0); --exponent 8 bits, but we need extra 1 for signed subtraction
    signal A_sign, B_sign, RESULT_sign: std_logic; --sign 1 bit  

begin

    process (clk, reset) is
        variable diff: signed(8 downto 0); --we will store exponents difference later
    begin
        if(reset = '1') then
            state <= WAIT_STATE;
            done    <= '0';
        elsif rising_edge(clk) then
            if (A = "00000000000000000000000000000000" and B = "00000000000000000000000000000000") then
                RESULT <= (others => '0');
                done <= '1';
                state <= OUT_STATE;
            else
                case state is
                    when WAIT_STATE =>
                        if (start = '1') then
                            A_sign <= A(31);
                            A_exponent <= '0' & A(30 downto 23);
                            A_mantissa <= "01" & A(22 downto 0); -- '1' hidden bit
                            B_sign <= B(31);
                            B_exponent <= '0' & B(30 downto 23);
                            B_mantissa <= "01" & B(22 downto 0);
                            state <= ALIGN_STATE;
                        else
                            state <= WAIT_STATE;
                        end if;
                    when ALIGN_STATE =>
                        if unsigned(A_exponent) > unsigned(B_exponent) then
                            diff := signed(A_exponent) - signed(B_exponent);
                            if diff > 23 then --B << A
                                RESULT_mantissa <= A_mantissa;
                                RESULT_exponent <= A_exponent;
                                RESULT_sign <= A_sign;
                                state <= OUT_STATE;
                            else --shift left B_mantissa
                                RESULT_exponent <= A_exponent;
                                B_mantissa(24-to_integer(diff) downto 0) <= B_mantissa(24 downto to_integer(diff));
                                B_mantissa(24 downto 25-to_integer(diff)) <= (others => '0');
                                state <= ADD_STATE;
                            end if;
                        elsif unsigned(A_exponent) < unsigned(B_exponent)  then
                            diff := signed(B_exponent) - signed(A_exponent);
                            if diff > 23 then --A << B
                                RESULT_mantissa <= B_mantissa;
                                RESULT_sign <= B_sign;
                                RESULT_exponent <= B_exponent;
                                state <= OUT_STATE;
                            else
                                RESULT_exponent <= B_exponent; --shift left A
                                A_mantissa(24-to_integer(diff) downto 0) <= A_mantissa(24 downto to_integer(diff));
                                A_mantissa(24 downto 25-to_integer(diff)) <= (others => '0');
                                state <= ADD_STATE;
                            end if;
                        else
                            RESULT_exponent <= A_exponent;
                            state <= ADD_STATE;
                        end if;
                    when ADD_STATE => --add the matissas
                        state <= NORM_STATE;
                        if (A_sign xor B_sign) = '0' then  --both same sign, just addition
                            RESULT_mantissa <= std_logic_vector((unsigned(A_mantissa) + unsigned(B_mantissa)));
                            RESULT_sign <= A_sign; --RESULT keeps the same sign
                        elsif unsigned(A_mantissa) >= unsigned(B_mantissa) then -- different signs, abs(A) > abs(B)
                            RESULT_mantissa <= std_logic_vector((unsigned(A_mantissa) - unsigned(B_mantissa)));
                            RESULT_sign <= A_sign; -- RESULT keeps sign of A
                        else
                            RESULT_mantissa <= std_logic_vector((unsigned(B_mantissa) - unsigned(A_mantissa)));-- different signs, abs(A) > abs(B)
                            RESULT_sign <= B_sign; -- RESULT keeps sign of B
                        end if;
                    when NORM_STATE =>  -- normalize the RESULT 
                        if unsigned(RESULT_mantissa) = TO_UNSIGNED(0, 25) then -- ==0
                            RESULT_mantissa <= (others => '0');
                            RESULT_exponent <= (others => '0');
                            state <= OUT_STATE;
                        elsif(RESULT_mantissa(24) = '1') then  --overflow case
                            RESULT_mantissa <= '0' & RESULT_mantissa(24 downto 1);  --shift right mantissa
                            RESULT_exponent <= std_logic_vector((unsigned(RESULT_exponent)+ 1)); --increase exponent
                            state <= OUT_STATE;
                        elsif(RESULT_mantissa(23) = '0') then  --we need 1
                            RESULT_mantissa <= RESULT_mantissa(23 downto 0) & '0';
                            RESULT_exponent <= std_logic_vector((unsigned(RESULT_exponent)-1));
                            state<= NORM_STATE; --we must check if it is still normalized or not
                        else
                            state <= OUT_STATE;  --is ok
                        end if;
                    when OUT_STATE =>
                        RESULT(22 downto 0)  <= RESULT_mantissa(22 downto 0);
                        RESULT(30 downto 23) <= RESULT_exponent(7 downto 0);
                        RESULT(31) <= RESULT_sign;
                        done <= '1';
                        if (start = '0') then -- a wait state, because if is not started, it can't be done
                            done    <= '0';
                            state <= WAIT_STATE;
                        end if;
                    when others =>
                        state <= WAIT_STATE;
                end case;
            end if;
        end if;
    end process;

end Behavioral;