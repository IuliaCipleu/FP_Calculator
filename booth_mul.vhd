library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity booth_mul is 
	generic (NBIT: integer:=NumBit);
	  port (a: in std_logic_vector(NBIT-1 downto 0); 
			  b: in std_logic_vector(NBIT-1 downto 0); 
			  p: out std_logic_vector(2*NBIT-1 downto 0)); 
end booth_mul;

architecture behavior of booth_mul is

	component booth_add 
		generic (NBIT: integer:=NumBit);
		port (a: in std_logic_vector(NBIT-1 downto 0);
				b: in std_logic_vector(2 downto 0);
				sum_in: in std_logic_vector(NBIT-1 downto 0);
				sum_out: out std_logic_vector(NBIT-1 downto 0);
				p: out std_logic_vector(1 downto 0));
	end component;
	
	signal start : std_logic_vector(NBIT-1 downto 0); 
	signal mul0: std_logic_vector(2 downto 0);
	type sum_array is array(0 to (NBIT/2)-1) of std_logic_vector(NBIT-1 downto 0);
	signal sum : sum_array;

	begin 
	
		start <= (others => '0'); 
		--p <=(others => '0');
		mul0 <= b(1 downto 0) & '0'; 
  
		ADDER0:  booth_add port map(a, mul0, start, sum(0), p(1 downto 0)); -- first adder/encoder/mux
  
		ADDER: for i in 1 to (NBIT/2)-2 generate 
			BOOTHADD:  booth_add port map(a, b((1+2*i) downto (2*i-1)), sum(i-1), sum(i), p((1+2*i) downto (2*i)));
		end generate;
  
		ADDERN: booth_add port map(a, b(NBIT-1 downto NBIT-3), sum((NBIT/2)-2), p(2*NBIT-1 downto NBIT), p(NBIT-1 downto NBIT-2)); -- last adder/encoder/mux

end behavior;  