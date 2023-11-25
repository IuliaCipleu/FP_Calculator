library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_8b_tb is
    --  Port ( );
end cla_8b_tb;

architecture Behavioral of cla_8b_tb is
    signal A, B, Sum : std_logic_vector(7 downto 0);
    signal Cin, Cout: std_logic;

    component carry_lookahead_adder_8b is
        Port ( A: in std_logic_vector(7 downto 0);
             B: in std_logic_vector(7 downto 0);
             Cin: in std_logic;
             Sum: out std_logic_vector(7 downto 0);
             Cout: out std_logic
            );
    end component;

begin
    uut: carry_lookahead_adder_8b
        port map (
            A => A,
            B => B,
            Sum => Sum,
            Cout => Cout,
            Cin => Cin
        );

    stim_proc: process
    begin
        wait for 10 ns;

        A <= "00001111";
        B <= "00001111";
        Cin <= '1';

        wait for 10 ns;

        A <= "00001010";
        B <= "00000111";
        Cin <= '0';

        wait for 10 ns;

        A <= "00001000";
        B <= "00001001";
        Cin <= '0';
        
        wait for 10 ns;

        A <= "01001000";
        B <= "11001001";
        Cin <= '1';
        
         wait for 10 ns;

        A <= "10000000";
        B <= "01111111";
        Cin <= '0';

        wait;

    end process;

end Behavioral;
