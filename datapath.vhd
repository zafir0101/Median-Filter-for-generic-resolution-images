--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 17, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição do bloco operativo. O processamento
--               é separado em três process: `WRITE_MEM_IN` - escreve a
--               imagem de entrada em uma memória interna -, `WRITE_MEM_OUT`
--               - escreve cada pixel processado em outra memória interna -               
--               e `LOAD_MEM_OUT` - le a memória escrita, retornando um pixel
--               por borda de relógio (os quais serão agrupados para formar o
--               arquivo `outfile.txt`).
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.median_filter_pack.all;


entity datapath is
    generic ( pixels : positive := 256 );
    port (
         c_signals    : in control_signals;
         clk          : in std_logic;
         A            : in unsigned(7 downto 0);
         S            : out unsigned(7 downto 0);
         end_n, end_k : out unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
         s_signals    : out status_signals
         );
    
end entity;

architecture datapath_arch of datapath is

    ------------------------------------- Records para cada contador
    signal s_from_n : status_signals := (
                                        image_done_signal => '0',
                                        contk_full => '0', 
                                        pipeline_ready => '0', 
                                        pipeline_full => '0',
                                        valid_out     => '0'
                                        );
    signal s_from_k : status_signals := (
                                        image_done_signal => '0',
                                        contk_full => '0',
                                        pipeline_ready => '0',
                                        pipeline_full => '0',
                                        valid_out     => '0'
                                        );
    --------------------------------------

    -------------------------------------- Signals para derivação de sinais de status
    signal col_valid                 : std_logic;
    --------------------------------------

    -------------------------------------- Instancianção das memórias internas
    signal in_mem   : int_mem(0 to Max_counter_n(pixels => PIXELS));
    signal out_mem  : int_mem(0 to Max_counter_k(pixels => PIXELS) + 1);
    --------------------------------------          
    
    -------------------------------------- Signals associados à pipeline
    signal c                    : unsigned(Cbits_length(pixels => pixels) - 1 downto 0);
    signal scope_filter         : nine_pixels_array;
    signal w00, w01, w02 : unsigned(7 downto 0) := (others => '0');
    signal w10, w11, w12 : unsigned(7 downto 0) := (others => '0');
    signal w20, w21, w22 : unsigned(7 downto 0) := (others => '0');
    --------------------------------------

    -------------------------------------- Signals associados aos endereços
    signal s_end_n : unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
    signal s_end_k : unsigned(Tbits_length(pixels => pixels) - 1 downto 0);
    --------------------------------------

    signal S_filter : unsigned(7 downto 0);

    begin

    WRITE_MEM_IN: process(clk)
    begin

        if rising_edge(clk) then
            if (c_signals.read_n = '1' and c_signals.pipeline_enable = '0') then
                in_mem(to_integer(s_end_n)) <= A;
            end if;
        end if;

    end process WRITE_MEM_IN;

    WRITE_MEM_OUT: process(clk)
    begin

        if rising_edge(clk) then
            if (c_signals.write_k = '1' and (c_signals.pipeline_enable = '1' or c_signals.z = '1')) then
                out_mem(to_integer(s_end_k)) <= S_filter;
            end if;
        end if;

    end process WRITE_MEM_OUT;


    LOAD_MEM_OUT: process(clk)
    begin
        if (s_end_k <= Max_counter_k(pixels => PIXELS)) then
            if rising_edge(clk) then
                if (c_signals.write_k = '1' and c_signals.pipeline_enable = '0' and c_signals.z = '0' and c_signals.read_n = '0')  then
                    S <= out_mem(to_integer(s_end_k));
                end if;
            end if;
        end if;
    
    end process LOAD_MEM_OUT;

    PIPELINE_3x3: process(clk)
    begin
        if rising_edge(clk) then
            if c_signals.pipeline_enable = '1' then
                
                w00 <= w01;
                w01 <= w02;
                w02 <= in_mem(to_integer(s_end_n));

                w10 <= w11;
                w11 <= w12;
                w12 <= in_mem(to_integer(s_end_n) + pixels);
                w20 <= w21;
                w21 <= w22;
                w22 <= in_mem(to_integer(s_end_n) + (2 * pixels));

            end if;
        end if;
    end process PIPELINE_3x3;

        scope_filter <= (
                        w00, w01, w02,
                        w10, w11, w12,
                        w20, w21, w22
                        );
    

        COUNTER_K: entity work.counter_k(struct)
            generic map ( pixels => pixels )
            port map(
                    clk       => clk,
                    c_signals => c_signals,
                    s_signals => s_from_k,
                    end_k     => s_end_k,
                    k         => open
                    );

        COUNTER_N: entity work.counter_n(struct)
            generic map ( pixels => pixels )
            port map(
                    clk       => clk,
                    c_signals => c_signals,
                    s_signals => s_from_n,
                    end_n     => s_end_n,
                    n         => open
                    );

        COUNTER_C: entity work.counter_c(struct)
            generic map ( pixels => pixels )
            port map(
                    clk       => clk,
                    c_signals => c_signals,
                    col_valid => col_valid,
                    c         => c
                    );

        
        

        FILTER: entity work.filter(struct)
        port map(
                array_to_be_sorted => scope_filter,
                S                  => S_filter
                );
    

    s_signals <= (
                image_done_signal    => s_from_k.image_done_signal,
                contk_full           => s_from_k.contk_full,
                pipeline_ready       => s_from_n.pipeline_ready,
                pipeline_full        => s_from_n.pipeline_full,
                valid_out            => col_valid
                );

    end_n <= s_end_n;
    end_k <= s_end_k;
end architecture datapath_arch;
