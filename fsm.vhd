--------------------------------------------------
--	Author:      Zafir Allan
--	Created:     Nov 17, 2025
--
--	Project:     Median Filter
--	Description: Contém a descrição da FSM responsável pelo funcionamento
--               do circuito. A FSM possui 7 estados e essa descrição a divide
--               em `STATE_PROCESS` - referente a transição de estado a partir
--               da borda de relógio e o funcionamento do reset -, `LPE`- referente
--               a lógica de próximo estado -, e, por fim, `LS` - referente a lógica
--               de saída de cada estado.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.median_filter_pack.all;


entity fsm is
    port(
        clk       : in std_logic;
        reset     : in std_logic;
        start     : in std_logic;
        s_signals : in status_signals;
        c_signals : out control_signals;
        image_done      : out std_logic;
        process_done    : out std_logic
        );
end entity;

architecture fsm_arch of fsm is

    type state is (
                    init,
                    load_mem_in,
                    first_pixel, 
                    process_state,
                    last_pixel,
                    load_mem_out,
                    finish_load_mem_out
                  );

    signal current_state, next_state : state;
    
    begin

        STATE_PROCESS : process(clk, reset)
        begin
            if reset = '1' then
                current_state <= init;
            elsif (rising_edge(clk)) then
                current_state <= next_state;
            end if;
        end process STATE_PROCESS;

        LPE : process(start, s_signals, current_state)
        begin
            case current_state is

                when init =>
                    if start = '1' then
                        next_state <= load_mem_in;
                    else
                        next_state <= init;
                    end if;

                when load_mem_in => 
                    if s_signals.pipeline_full = '1' then
                        next_state <= first_pixel;
                    else
                        next_state <= load_mem_in;
                    end if;

                when first_pixel => next_state <= process_state;

                when process_state =>
                    if s_signals.contk_full = '0' then
                        next_state <= process_state;
                    else
                        next_state <= last_pixel;
                    end if;
                
                when last_pixel => next_state <= load_mem_out;

                when load_mem_out =>
                    if s_signals.contk_full = '0' then
                        next_state <= load_mem_out;
                    else
                        next_state <= finish_load_mem_out;
                    end if;

                when finish_load_mem_out =>
                    if s_signals.image_done_signal = '1' then
                        next_state <= init;
                    else
                        next_state <= finish_load_mem_out;
                    end if;

            end case;
        end process LPE;

        LS : process(current_state, s_signals.valid_out)
        begin
            case current_state is
            
                when init =>
                    image_done                  <= '1';
                    process_done                <= '0';
                    c_signals.read_n            <= '0';
                    c_signals.write_k           <= '0';
                    c_signals.z                 <= '1';
                    c_signals.zn                <= '1';                    
                    c_signals.pipeline_enable   <= '0';
                    
                when load_mem_in =>
                    image_done                  <= '0';
                    process_done                <= '0';
                    c_signals.read_n            <= '1';
                    c_signals.write_k           <= '0';
                    c_signals.z                 <= '0';
                    c_signals.zn                <= '0';
                    c_signals.pipeline_enable   <= '0';

                when first_pixel =>
                    image_done                  <= '0';
                    process_done                <= '0';
                    c_signals.read_n            <= '1';
                    c_signals.write_k           <= '0';
                    c_signals.z                 <= '1';
                    c_signals.zn                <= '0';
                    c_signals.pipeline_enable   <= '1';

                when process_state =>
                    image_done                  <= '0';
                    process_done                <= '0';
                    c_signals.read_n            <= '1';
                    c_signals.write_k           <= s_signals.valid_out;
                    c_signals.z                 <= '0';
                    c_signals.zn                <= '0';
                    c_signals.pipeline_enable   <= '1';
                
                when last_pixel =>
                    image_done                  <= '0';
                    process_done                <= '0';
                    c_signals.read_n            <= '0';
                    c_signals.write_k           <= '1';
                    c_signals.z                 <= '1';
                    c_signals.zn                <= '0';
                    c_signals.pipeline_enable   <= '0';
                
                when load_mem_out =>
                    image_done                  <= '0';
                    process_done                <= '1';
                    c_signals.read_n            <= '0';
                    c_signals.write_k           <= '1';
                    c_signals.z                 <= '0';
                    c_signals.zn                <= '0';
                    c_signals.pipeline_enable   <= '0';

                when finish_load_mem_out =>
                    image_done                  <= '0';
                    process_done                <= '1';
                    c_signals.read_n            <= '0';
                    c_signals.write_k           <= '1';
                    c_signals.z                 <= '0';
                    c_signals.zn                <= '0';
                    c_signals.pipeline_enable   <= '0';

            end case;
        end process LS;
end architecture fsm_arch;
                    