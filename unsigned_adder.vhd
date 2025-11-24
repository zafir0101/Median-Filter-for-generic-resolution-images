--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um somador entre
--               dois valores sem sinal de N bits. A saída `sum` possui
--               N bits desconsiderando um possível carry out da operação.
--               Todas as portas utilizam o tipo `unsigned`.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unsigned_adder is
	generic( N : positive := 8 );
	port(
		input_a : in  unsigned(N - 1 downto 0); 
		input_b : in  unsigned(N - 1 downto 0); 
		sum     : out unsigned(N - 1 downto 0)
    	);
end entity;

architecture behavior of unsigned_adder is
begin

    sum <= input_a + input_b;

end architecture behavior;