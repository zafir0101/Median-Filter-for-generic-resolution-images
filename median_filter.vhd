--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 17, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição do top-level do circuito projetado.
--               Foi utilizada a abordagem BO/BC para o projeto, records 
--               para a comunicação entre o bloco operativo e o bloco de 
--               controle, além de sinais de indicação como `image_done` e
--               e `process_done`.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.median_filter_pack.all;


entity median_filter is
    generic ( pixels : positive := 256 );
    port(
        clk     : in std_logic;
        reset   : in std_logic;
        start   : in std_logic;
        A       : in unsigned(7 downto 0);
        S       : out unsigned(7 downto 0);
        end_n   : out unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
        end_k   : out unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
        image_done    : out std_logic;
        process_done  : out std_logic;
        write_k : out std_logic;
        read_n  : out std_logic
        );

end entity;

architecture arch of median_filter is

    signal c_signals : control_signals;
    signal s_signals : status_signals;

    begin
        BC : entity work.fsm(fsm_arch)
            port map(
                    clk         => clk,
                    start       => start,
                    reset       => reset,
                    s_signals   => s_signals,
                    c_signals   => c_signals,
                    image_done        => image_done,
                    process_done      => process_done
                    );

        BO : entity work.datapath(datapath_arch)
            generic map ( pixels => pixels )
            port map(
                    c_signals => c_signals,
                    clk       => clk,
                    A         => A,
                    S         => S,
                    end_n     => end_n,
                    end_k     => end_k,
                    s_signals => s_signals
                    );

        read_n  <= c_signals.read_n;
        write_k <= c_signals.write_k;
end architecture arch;