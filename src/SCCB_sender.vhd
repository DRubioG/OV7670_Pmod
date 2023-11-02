library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SCCB_sender is
    port (
        clk : in std_logic;
        SIOD : inout std_logic;
        SIOC : out std_logic;
        taken : out std_logic;
        send : in std_logic;
        id : in std_logic_vector(7 downto 0);
        reg : in std_logic_vector(7 downto 0);
        value : in std_logic_vector(7 downto 0)
    );
end entity;

architecture Behavioral of SCCB_sender is

signal pausa : unsigned(7 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then

            -- INICIO DE TRANSMISION -- Una transmision completa para cada registro

            if send = '1' and busy_aux = '0' then
                if pausa = "00000001" then
                    SIOC <= '1';
                    SIOD <= '1';
                    taken <= '0';
                    pausa <= pausa + 1;
                    data <= id & reg & value;
                else
                    if pausa = "00111110" then
                        SIOD <= '0';
                        pausa <= pausa + 1;
                    end if;
                    pausa <= pausa + 1;
                    if pausa = "01111110" then
                        SIOC <= '0';
                        busy_aux <= '1';
                        SIOD <= data(23);
                        data <= data(22 downto 0) & '0';
                        contador <= contador + 1;
                        pausa <= "00000001";
                    end if;
                end if;
            end if;

            -- TRANSMISION DE DATOS --

            if busy_aux = '1' then
                if contador2 /= "11" then
                    if pausa = "11111010" then
                        SIOC <= '0';
                        pausa <= "00000001";
                        if contador = "1000" then
                            contador <= "0000";
                            contador <= contador2 + 1;
                            SIOD <= 'Z';
                        else
                            SIOD <= data(23);
                            data <= data(22 downto 0) & '0';
                            contador <= contador + 1;
                        end if;
                    elsif pausa = "011111101" then
                        SIOC <= '1';
                        pausa <= pausa + 1;
                    else
                        pausa <= pausa + 1;
                    end if;
                else

                -- FIN TRANSMISION --

                    if pausa = "11111010" then
                        if click = '0' then
                            SIOC <= '0';
                            SIOD <= '0';
                            click <= '1';
                        else
                            busy_aux <= '0';
                            SIOD <= '1';
                            SIOC <= '1';
                            contador2 <= "00";
                            taken <= '1';
                            click <= '0';
                        end if;
                        pausa <= "00000001";
                    elsif pausa = "01111110" then
                        SIOC <= '1';
                        pausa <= pausa +1;
                    else
                        pausa <= pausa +1;
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture;