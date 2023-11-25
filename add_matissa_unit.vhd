----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2023 08:16:20 PM
-- Design Name: 
-- Module Name: add_matissa_unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity add_matissa_unit is
    Port ( signA : in STD_LOGIC;
         signB : in STD_LOGIC;
         mantissaA : in STD_LOGIC_VECTOR (22 downto 0);
         mantissaB : in STD_LOGIC_VECTOR (22 downto 0);
         clk: in std_logic;
         mantissaOut : out STD_LOGIC_VECTOR (22 downto 0);
         signOut: out std_logic;
         overflow: out std_logic);
end add_matissa_unit;

architecture Behavioral of add_matissa_unit is
    component subtract_23b is
        Port (
            A: in std_logic_vector(22 downto 0);
            B: in std_logic_vector(22 downto 0);
            Sub: out std_logic_vector(22 downto 0);
            Borrow: out std_logic
        );
    end component;

    component carry_lookahead_adder_23b
        Port ( A : in std_logic_vector(22 downto 0);
             B : in std_logic_vector(22 downto 0);
             Cin : in std_logic;
             Sum : out std_logic_vector(22 downto 0);
             Cout : out std_logic
            );
    end component;

    signal mantissaSum, mantissaAB, mantissaBA: std_logic_vector(22 downto 0);
    signal coutSum, borrowA, borrowB: std_logic;
begin
    addMantissa: carry_lookahead_adder_23b port map (mantissaA, mantissaB, '0', mantissaSum, coutSum);
    subAB: subtract_23b port map (mantissaA, mantissaB, mantissaAB, borrowA);
    subBA: subtract_23b port map (mantissaB, mantissaA, mantissaBA, borrowB);

    process (clk, mantissaA, mantissaB)
    begin
        if rising_edge(clk) then
            if signA = signB then
                mantissaOut <= mantissaSum;
                signOut <= signA;
                overflow <= coutSum;
            else
                if unsigned(mantissaA) > unsigned(mantissaB) then
                    mantissaOut <= mantissaAB;
                    signOut <= signA;
                    Overflow <= borrowA;
                else
                    mantissaOut <= mantissaBA;
                    signOut <= signB;
                    Overflow <= borrowB;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
