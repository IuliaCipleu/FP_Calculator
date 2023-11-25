library ieee; 
use ieee.std_logic_1164.all; 
use WORK.constants.all;

entity rca_generic is
	generic (NBIT: integer:=NumBit);
	Port(	a:	in	std_logic_vector(NBIT-1 downto 0);
			b:	in	std_logic_vector(NBIT-1 downto 0);
			ci: in std_logic;
			s:	out std_logic_vector(NBIT-1 downto 0);
			co: out std_logic);
end rca_generic; 

architecture structural of rca_generic is

	component full_adder is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC);
end component; 
  
	signal s_tmp : std_logic_vector(NBIT-1 downto 0);
	signal c_tmp : std_logic_vector(NBIT downto 0);

begin

	c_tmp(0) <= ci;
	  
	ADDER1: for i in 1 to NBIT generate
		FAI : full_adder Port Map (a(i-1), b(i-1), c_tmp(i-1), s_tmp(i-1), c_tmp(i)); 
	end generate;
  
	s <= s_tmp;
	co <= c_tmp(NBIT);

end structural;