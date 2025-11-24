--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um contador de pixels escritos. As entradas são o sinal
--               de controle `z` que reseta o contador e o sinal `write`, que
--               representa o enable do registrador K. A saída é o sinal de status `contk_full`,
--               que indica que todos os pixels foram escritos.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity counter_k is
    generic( pixels : positive := 256 );
    port(
        clk             : in std_logic;
        c_signals       : in control_signals;
        s_signals       : out status_signals;
        end_k           : out unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
        k               : out unsigned(Tbits_length(pixels => pixels) - 1 downto 0)
        );
end entity;

architecture struct of counter_k is

    signal k_sum, k_reg : unsigned(Tbits_length(pixels => pixels) - 1 downto 0);

begin

    REGISTER_K   : entity work.unsigned_register(behavior)
        generic map( N => Tbits_length(pixels => pixels) )
        port map(
                clk     => clk,
                enable  => c_signals.write_k,
                reset   => c_signals.z,
                d       => k_sum,
                q       => k_reg
                );
    
    ADDER_K      : entity work.unsigned_adder(behavior)
        generic map( N => Tbits_length(pixels => pixels) )
        port map(
                input_a => k_reg,
                input_b => to_unsigned(1, Tbits_length(pixels => pixels)),
                sum     => k_sum
                );

    COMPARATOR_K : entity work.comparator_k(behavior)
        generic map( pixels => pixels )
        port map(
                k_reg      => k_reg,
                contk_full => s_signals.contk_full,
                image_done_signal => s_signals.image_done_signal
                );

    k     <= k_reg;
    end_k <= k_reg;
    
end architecture struct;

