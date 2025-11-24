--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um registrador com controle
--               de carga (sinal enable). O registrador armazena valores sem sinal
--               de N bits na borda de subida do clock, desde que `enable` esteja
--               em nível lógico alto. As entradas e saídas utilizam o tipo `unsigned`.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity unsigned_register is
	generic( N : positive := 8 );
	port(
		clk         : in  std_logic;                
        enable      : in std_logic;
        reset       : in std_logic;
		d           : in  unsigned(N - 1 downto 0); 
		q           : out unsigned(N - 1 downto 0)
	    );
end entity;

architecture behavior of unsigned_register is
begin
    
    process(clk, reset)
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                    q <= (others => '0');
            elsif (enable = '1') then
                    q <= d;        
            end if;
        end if;
    end process;

end architecture behavior;
