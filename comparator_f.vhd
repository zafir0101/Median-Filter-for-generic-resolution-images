--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um comparador que verifica
--               se `is_extreme` é 0 ou 1, ou seja, se o pixel central
--               é um valor extremo (maior que 250 ou menor que 5) ou não.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity comparator_f is
    port(
        pixel       : in unsigned(7 downto 0);
        is_extreme  : out std_logic
        );
end entity;

architecture behavior of comparator_f is
    begin

    is_extreme <= '1' when (pixel >= 250 or pixel <= 5) else '0';

end architecture behavior;
