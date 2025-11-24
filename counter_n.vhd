--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 15, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição de um contador de pixels lidos. As entradas são o sinal
--               de controle `z` que reseta o contador e o sinal `read`, que
--               representa o enable do registrador N. A saída é o sinal de status `pipeline_full`
--               que indica que todos os pixels foram lidos.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity counter_n is
    generic( pixels : positive := 256 );
    port(
        clk             : in std_logic;
        c_signals       : in control_signals;
        s_signals       : out status_signals;
        end_n           : out unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
        n               : out unsigned(Tbits_length(pixels => pixels) - 1 downto 0)
        );
end entity;

architecture struct of counter_n is

    signal n_sum, n_reg : unsigned(Tbits_length(pixels => pixels) - 1 downto 0) := (others => '0');

begin

    REGISTER_N   : entity work.unsigned_register(behavior)
        generic map( N => Tbits_length(pixels => pixels) )
        port map(
                clk     => clk,
                enable  => c_signals.read_n,
                reset   => c_signals.zn,
                d       => n_sum,
                q       => n_reg
                );
    
    ADDER_N      : entity work.unsigned_adder(behavior)
        generic map( N => Tbits_length(pixels => pixels) )
        port map(
                input_a => n_reg,
                input_b => to_unsigned(1, Tbits_length(pixels => pixels)),
                sum     => n_sum
                );

    COMPARATOR_N_1 : entity work.comparator_n_1(behavior)
        generic map( pixels => pixels )
        port map(
                n_reg         => n_reg,
                pipeline_full => s_signals.pipeline_full
                );

    n     <= n_reg;
    end_n <= n_reg;

end architecture struct;

