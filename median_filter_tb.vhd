--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 18, 2025
--
--	Project:     Median Filter
--	Description: Contém a testbench referente ao módulo `median_filter`.
--               Essa testbench é responsável por testar o funcionameto
--               do circuito como um todo. Foi utilizado a biblioteca
--               TEXTIO para a leitura e escrita de arquivos. De modo geral
--               esse arquivo simula o funcionamento do circuito, lendo um
--               arquivo de entrada txt no qual cada linha representa um pixel
--               em decimal, e retorna um arquivo de saída no mesmo formato com
--               a imagem já processada.
--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.median_filter_pack.all;
library std;
use std.textio.all;


entity median_filter_tb is
end entity;

architecture sim of median_filter_tb is

    constant PIXELS : positive := 256;
    constant CLK_PERIOD : time := 10 ns;

    signal clk     : std_logic;
    signal reset   : std_logic;
    signal start   : std_logic;
    signal A       : unsigned(7 downto 0) := (others => '0');
    signal S       : unsigned(7 downto 0);
    signal end_n   : unsigned(Tbits_length(pixels => PIXELS) - 1 downto 0);
    signal end_k   : unsigned(Tbits_length(pixels => PIXELS) - 1 downto 0);
    signal image_done, process_done    : std_logic;
    signal write_k : std_logic;
    signal read_n  : std_logic;

    begin

        TOP_LEVEL : entity work.median_filter(arch)
        generic map ( pixels => PIXELS )
        port map (
            clk   => clk,
            reset => reset,
            start => start,
            A     => A,
            S     => S,
            end_n => end_n,
            end_k => end_k,
            image_done => image_done,
            process_done  => process_done,
            write_k => write_k,
            read_n  => read_n
        );

        CLK_PROCESS : process
        begin
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end process;

        TB_PROCESS : process

        file infile      : text open read_mode is "infile.txt";
        file outfile     : text open write_mode is "outfile.txt";

        variable file_line : line;
        variable out_line  : line;
        variable pixel : integer;

        begin

        reset <= '1';
        report "Starting" severity note;
        wait until (rising_edge(clk));

        reset <= '0';
        start <= '1';
        wait until (rising_edge(clk));

        start <= '0';

        report "Reading to internal memory" severity note;
        while not endfile(infile) loop

            readline(infile, file_line);
            read(file_line, pixel);
            A <= to_unsigned(pixel, 8);
            wait until (rising_edge(clk));

        end loop;
        report "Reading completed" severity note;

        report "Processing image" severity note;
        while (read_n = '1') loop

            wait until (rising_edge(clk));

        end loop;
        report "Processing completed" severity note;

        wait until (rising_edge(clk));
        wait until (rising_edge(clk));

        report "Writing to internal memory" severity note;
        while (process_done = '1') loop

            write(out_line, to_integer(S));
            writeline(outfile, out_line);
            wait until (rising_edge(clk));
        
        end loop;
        report "Writing completed" severity note;

        if (image_done = '1') then
            report "Image is ready" severity note;
        end if;

        file_close(outfile);        
        std.env.finish;
        wait;

        end process;
    
end architecture sim;