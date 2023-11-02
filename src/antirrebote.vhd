library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity antirrebote is
    port (
        clk : in std_logic;
        i : in std_logic;
        o : out std_logic
    );
end entity;

architecture Behavioral of antirrebote is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if i = '1' then
                if contador = x"FFFFFF" then
                    o <= '1';
                else 
                    o <= '0';
                end if;
                contador <= contador + 1;
            else
                contador <= (others=>'0');
                o <= '0';
            end if;
        end if;
    end process;
end architecture;