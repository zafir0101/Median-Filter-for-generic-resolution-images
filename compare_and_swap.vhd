--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 16, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição do CAS - bloco que recebe dois
--               valores de entrada e retorna os valores ordenados.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity compare_and_swap is
    port(
        A       : in unsigned(7 downto 0);
        B       : in unsigned(7 downto 0);
        bigger  : out unsigned(7 downto 0);
        smaller : out unsigned(7 downto 0)
        );
end entity;

architecture behavior of compare_and_swap is
    begin

    bigger  <= A when A > B else B;
    smaller <= B when A > B else A;

end architecture behavior;