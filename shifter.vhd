----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/29/2023 03:58:15 PM
-- Design Name: 
-- Module Name: shifter32 - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shifter32 is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
         DIR : in STD_LOGIC;
         RESULT : out STD_LOGIC_VECTOR(31 downto 0));
end shifter32;

architecture Behavioral of shifter32 is
begin
    process(DIR)
    begin
        if DIR = '0' then
            RESULT <= A(30 downto 0) & '0'; -- Shift left (Logical shift left) by 1 bit
        else
            RESULT <= '0' & A(31 downto 1); -- Shift right (Logical shift right) by 1 bit
        end if;
    end process;
end Behavioral;
