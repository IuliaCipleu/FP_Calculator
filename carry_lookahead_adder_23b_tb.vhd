library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity carry_lookahead_adder_23b_tb is
--Port()
end carry_lookahead_adder_23b_tb;

architecture behavior of carry_lookahead_adder_23b_tb is
  signal A, B, Sum : std_logic_vector(22 downto 0);
  signal Cin, Cout : std_logic;

  component carry_lookahead_adder_23b
    Port ( A : in std_logic_vector(22 downto 0);
           B : in std_logic_vector(22 downto 0);
           Cin : in std_logic;
           Sum : out std_logic_vector(22 downto 0);
           Cout : out std_logic
    );
  end component;

  begin
    uut: carry_lookahead_adder_23b
    port map (
      A => A,
      B => B,
      Cin => Cin,
      Sum => Sum,
      Cout => Cout
    );

    stimulus: process
    begin
      A <= (others => '0');
      B <= (others => '0');
      A(15 downto 12) <= "1010"; 
      B(15 downto 12) <= "1100";
      Cin <= '0'; 

      wait for 10 ns;

      A <= (others => '0');
      B <= (others => '0');
      A(10 downto 8) <= "111"; 
      B(10 downto 8) <= "001";
      Cin <= '1'; 

      wait for 10 ns;

      A <= (others => '0');
      B <= (others => '0');
      A(10 downto 8) <= "000"; 
      B(10 downto 8) <= "001";
      Cin <= '1';
      
      wait for 10 ns;
      
      A <= (others => '0');
      B <= (others => '0');
      A(19 downto 8) <= "010100110111"; 
      B(19 downto 8) <= "111010010001";
      Cin <= '0';

      wait;
    end process;

  end behavior;
