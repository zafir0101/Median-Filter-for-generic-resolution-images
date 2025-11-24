--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um comparador que verifica
--               se `c_reg` é 0 ou 1, ou seja, se a coluna é válida.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity comparator_c is
    generic( pixels : positive := 256 );
    port(
        c_reg       : in unsigned(Cbits_length(pixels => pixels) - 1 downto 0);
        col_valid   : out std_logic
        );
end entity;

architecture behavior of comparator_c is
    begin

        col_valid <= '0' when (c_reg = 0) or (c_reg = 1) else '1';

end architecture behavior;
