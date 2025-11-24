--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um contador de colunas. As entradas são o sinal
--               de controle `z` que reseta o contador e o sinal `pipeline_enable`, que
--               representa o enable do registrador C. A saída é o sinal auxiliar `col_valid`,
--               que indica quando uma coluna é válida.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity counter_c is
    generic( pixels: positive := 256 );
    port(
        clk             : in std_logic;
        c_signals       : in control_signals;
        col_valid       : out std_logic;
        c               : out unsigned(Cbits_length(pixels => pixels) - 1 downto 0)
        );
end entity;

architecture struct of counter_c is

    signal c_sum, c_reg : unsigned(Cbits_length(pixels => pixels) - 1 downto 0);

begin

    REGISTER_C   : entity work.unsigned_register(behavior)
        generic map( N => Cbits_length(pixels => pixels) )
        port map(
                clk     => clk,
                enable  => c_signals.pipeline_enable,
                reset   => c_signals.z,
                d       => c_sum,
                q       => c_reg
                );
    
    ADDER_C      : entity work.unsigned_adder(behavior)
        generic map( N => Cbits_length(pixels => pixels) )
        port map(
                input_a => c_reg,
                input_b => to_unsigned(1, Cbits_length(pixels => pixels)),
                sum     => c_sum
                );

    COMPARATOR_C : entity work.comparator_c(behavior)
        generic map( pixels => pixels )
        port map(
                c_reg     => c_reg,
                col_valid => col_valid
                );

    c <= c_reg;
    
end architecture struct;

