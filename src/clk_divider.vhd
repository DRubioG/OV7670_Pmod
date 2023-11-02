library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_divider is
    port(
        clk100 : in std_logic;
        clk50 : out std_logic;
        clk25 : out std_logic
    );
end entity;

architecture Behavioral of clk_divider is 
begin
    clk50 <= clk50a;
    clk25 <= clk25a;
    process(clk100)
    begin
        if rising_edge(clk) then
            clk50a <= not clk50a;
            if rising_edge(clk50) then
                clk25 <= not clk25;
            end if;
        end if;
    end process;
    
end architecture;