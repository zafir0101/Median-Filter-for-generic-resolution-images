--------------------------------------------------
--  Author:      Zafir Allan
--	Created:     Nov 16, 2025
--
--  Project:     Median Filter
--  Description: Rede para calcular a mediana de 9 valores
--               utilizando uma median network.
--               > Observação: Foi alterado o algoritmo de ordenação
--               > utilizado no projeto(anteriormente Sorting Network) a fim de otimizar o
--               > circuito.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.median_filter_pack.all;

entity median_network is
    port(
        array_to_be_sorted : in  nine_pixels_array;
        median             : out unsigned(7 downto 0)
        );
end entity;

architecture behavior of median_network is

    signal layer0, layer1, layer2, layer3, layer4, layer5, layer6, layer7 : nine_pixels_array;

begin

----------------------------------------------- Camada 0
    CAS_01_0 : entity work.compare_and_swap(behavior)
        port map(
            A       => array_to_be_sorted(0),
            B       => array_to_be_sorted(1),
            bigger  => layer0(0), 
            smaller => layer0(1) 
        );

    layer0(2) <= array_to_be_sorted(2);
    
    CAS_34_0 : entity work.compare_and_swap(behavior)
        port map(
            A       => array_to_be_sorted(3),
            B       => array_to_be_sorted(4),
            bigger  => layer0(3),
            smaller => layer0(4)
        );

    layer0(5) <= array_to_be_sorted(5);

    CAS_67_0 : entity work.compare_and_swap(behavior)
        port map(
            A       => array_to_be_sorted(6),
            B       => array_to_be_sorted(7),
            bigger  => layer0(6),
            smaller => layer0(7)
        );

    layer0(8) <= array_to_be_sorted(8);
-----------------------------------------------

----------------------------------------------- Camada 1
    layer1(0) <= layer0(0);

    CAS_12_1 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer0(1),
            B       => layer0(2),
            bigger  => layer1(1), 
            smaller => layer1(2) 
        );

    layer1(3) <= layer0(3);

    CAS_45_1 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer0(4),
            B       => layer0(5),
            bigger  => layer1(4),
            smaller => layer1(5)
        );

    layer1(6) <= layer0(6);

    CAS_78_1 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer0(7),
            B       => layer0(8),
            bigger  => layer1(7),
            smaller => layer1(8)
        );
-----------------------------------------------

----------------------------------------------- Camada 2
    CAS_01_2 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer1(0),
            B       => layer1(1),
            bigger  => layer2(0),
            smaller => layer2(1)
        );

    layer2(3) <= layer1(2);

    CAS_34_2 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer1(3),
            B       => layer1(4),
            bigger  => layer2(2),
            smaller => layer2(4)
        );

    layer2(6) <= layer1(5);

    CAS_67_2 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer1(6),
            B       => layer1(7),
            bigger  => layer2(5),
            smaller => layer2(7)
        );

    layer2(8) <= layer1(8);
-----------------------------------------------

----------------------------------------------- Camada 3
    CAS_02_3 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer2(0),
            B       => layer2(2),
            bigger  => open,
            smaller => layer3(0)
        );

    layer3(2) <= layer2(3);

    CAS_14_3 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer2(1),
            B       => layer2(4),
            bigger  => layer3(3),
            smaller => layer3(4)
        );

    layer3(1) <= layer2(5);

    CAS_68_3 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer2(6),
            B       => layer2(8),
            bigger  => layer3(6),
            smaller => open
        );

    layer3(5) <= layer2(7);
-----------------------------------------------

----------------------------------------------- Camada 4
    CAS_01_4 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer3(0),
            B       => layer3(1),
            bigger  => open,
            smaller => layer4(0)
        );

    layer4(1) <= layer3(3);

    CAS_45_4 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer3(4),
            B       => layer3(5),
            bigger  => layer4(2),
            smaller => open
        );

    CAS_26_4 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer3(2),
            B       => layer3(6),
            bigger  => layer4(3),
            smaller => open
        );
-----------------------------------------------

----------------------------------------------- Camada 5
    CAS_12_5 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer4(1),
            B       => layer4(2),
            bigger  => open,
            smaller => layer5(1)
        );

    layer5(0) <= layer4(0);
    layer5(2) <= layer4(3);
-----------------------------------------------

----------------------------------------------- Camada 6
    CAS_01_6 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer5(0),
            B       => layer5(1),
            bigger  => layer6(0),
            smaller => layer6(1)
        );
        
    layer6(2) <= layer5(2);
-----------------------------------------------

----------------------------------------------- Camada 7
    CAS_12_7 : entity work.compare_and_swap(behavior)
        port map(
            A       => layer6(1),
            B       => layer6(2),
            bigger  => layer7(1),
            smaller => open
        );

    layer7(0) <= layer6(0);
-----------------------------------------------

----------------------------------------------- Camada 8
    CAS_01_8 : entity work.compare_and_swap(behavior)
            port map(
                A       => layer7(0),
                B       => layer7(1),
                bigger  => open,
                smaller => median
            );

end architecture behavior;
