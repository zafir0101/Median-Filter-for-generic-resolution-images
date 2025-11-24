--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Este pacote contém definições de tipos e funções auxiliares que
--               irão ser utilizadas no projeto.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package median_filter_pack is

-------------------------------------------------- Declaração de tipos
    type int_mem is array (natural range <>) of unsigned(7 downto 0);

    type nine_pixels_array is array (0 to 8) of unsigned(7 downto 0);

    type control_signals is record
        z                 : std_logic;
        zn                : std_logic;
        pipeline_enable   : std_logic;
        read_n            : std_logic;
        write_k           : std_logic;
    end record;
    
    type status_signals is record
        image_done_signal    : std_logic;
        contk_full           : std_logic;
        pipeline_ready       : std_logic;
        pipeline_full        : std_logic;
        valid_out            : std_logic;
    end record;
--------------------------------------------------

-------------------------------------------------- Declaração de funções
    function Cbits_length(pixels : positive)
    return positive;

    function Tbits_length(pixels : positive)
    return positive;

    function Max_counter_k(pixels : positive)
    return positive;

    function Max_counter_n(pixels : positive)
    return positive;
--------------------------------------------------

end package median_filter_pack;

package body median_filter_pack is

    function Cbits_length(pixels : positive)
    return positive is
    begin
        return integer(ceil(log2(real(pixels))));
    end function Cbits_length;

    function Tbits_length(pixels : positive)
    return positive is
    begin
        return integer(ceil(log2(real(pixels * pixels))));
    end function Tbits_length;

    function Max_counter_k(pixels : positive)
    return positive is
    begin
        return integer((pixels - 2) * (pixels - 2) - 2);
    end function Max_counter_k;
    
    function Max_counter_n(pixels : positive)
    return positive is
    begin
        return integer((pixels * pixels) - 1);
    end function Max_counter_n;

end package body median_filter_pack;