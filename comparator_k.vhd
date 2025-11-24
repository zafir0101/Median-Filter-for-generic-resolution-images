--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um comparador que verifica
--               se `contk_full` é 0 ou 1, ou seja, se todos os
--               pixels foram escritos.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity comparator_k is
    generic( pixels : positive := 256 );
    port(
        k_reg       : in unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
        contk_full  : out std_logic;
        image_done_signal : out std_logic
        );
end entity;

architecture behavior of comparator_k is
    begin

    contk_full <= '1' when (k_reg >= Max_counter_k(pixels => pixels)) else '0';
    image_done_signal <= '1' when (k_reg >= Max_counter_k(pixels => pixels) + 2) else '0';
    
end architecture behavior;
