--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 16, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição do filtro condicional
--               de mediana. Caso o pixel central for um valor
--               extremo esse componente retorna a mediana da janela
--               3x3.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity filter is
    port(
        array_to_be_sorted : in nine_pixels_array;
        S             : out unsigned(7 downto 0)
        );
end entity;

architecture struct of filter is

    signal median     : unsigned(7 downto 0);
    signal is_extreme : std_logic;

begin

    MEDIAN_NETWORK : entity work.median_network(behavior)
        port map(array_to_be_sorted => array_to_be_sorted, median => median);

    COMPAROTOR_F : entity work.comparator_f(behavior)
        port map(pixel => array_to_be_sorted(4), is_extreme => is_extreme);
    
    MUX_2TO1 : entity work.mux_2to1(behavior)
        port map(sel => is_extreme, input_a => array_to_be_sorted(4), input_b => median, y => S);

end architecture struct;
