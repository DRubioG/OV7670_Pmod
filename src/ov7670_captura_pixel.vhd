library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_captura_pixel is
    port (
            pclk : in std_logic;
            vsync : in std_logic;
            href : in std_logic;
            data : in std_logic_vector(7 downto 0);
            addr : in std_logic_vector(18 downto 0);
            dout : out std_logic_vector(11 downto 0);
            we : out std_logic
    );
end ov7670_captura_pixel;

architecture Behavioral of ov7670_captura_pixel is

begin
    addr <= addr_aux;
    dout <= rojo(4 downto 1) & verde (4 downto 1) & azul (4 downto 1);

    captura_pixel : process(pclk)
    begin
        if rising_edge(pclk) then
            if vsync = '1' then
                addr_aux <= (others=>'0');
                we <= '0';
                ciclo <= '0';
            else    
                if href = '1' then
                    if ciclo = '0' then
                        rojo <= data (6 downto 2);
                        verde <= data (1 downto 0) & "000";
                        we <= '0';
                        ciclo <= '1';
                    else
                        verde <= verde(4 downto 3) & data(7 downto 5);
                        azul <= data(4 downto 0);
                        we <= '1';
                        ciclo <= '0';
                        addr_aux <= std_logic_vector(unsigned(add_aux)+1);
                    end if;
                else
                    ciclo <= '0';
                    we <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture;