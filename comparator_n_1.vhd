--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um comparador que verifica
--               se `pipleine_full` é 0 ou 1, ou seja, se todos os
--               pixels foram lidos.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity comparator_n_1 is
    generic( pixels : positive := 256 );
    port(
        n_reg          : in unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
        pipeline_full  : out std_logic
        );
end entity;

architecture behavior of comparator_n_1 is
    begin

    pipeline_full <= '1' when (n_reg >= Max_counter_n(pixels => pixels)) else '0';

end architecture behavior;
