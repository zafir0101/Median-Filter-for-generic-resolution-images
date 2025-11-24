--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um multiplexador
--               2:1 parametrizável para N bits. A saída `y` será igual a
--               `input_a` quando `sel = '0'`, e igual a `input_b` quando `sel = '1'`.
--               As entradas e saídas são vetores com N bits.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2to1 is
	generic( N : positive := 8 );
	port(
		sel        		 : in  std_logic;                        
		input_a, input_b : in  unsigned(N - 1 downto 0); 
		y          		 : out unsigned(N - 1 downto 0)	
        );
end entity;

architecture behavior of mux_2to1 is
begin
   
    y <= input_a when sel = '0' else input_b;

end architecture behavior;
