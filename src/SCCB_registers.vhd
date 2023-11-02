library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SCCB_registers is
    port (
        clk : in std_logic;
        resend : in std_logic;
        advance : in std_logic;
        command : out std_logic_vector (15 downto 0);
        finished : out std_logic
    );
end entity;

architecture Behavioral of SCCB_registers is
begin
    commnand <= sreg;

    process (clk)
    begin
        if rising_edge(clk) then
            if resend = '1' then
                address <= (others=>'0');
            elsif advance = '1' then
                address <= std_logic_vector(unsigned(address)+1);
            end if;

            case address is 
                when x"00" => 
                    sreg <= x"1280";
                when x"01" =>
                    sreg <= x"1204";
                when x"02" =>
                    sreg <= x"B084";
                when x"03" =>
                    sreg <= x"6BCA";

            -- Espacio reservado para más registros --
            
                when others => 
                    sreg <= x"FFFF";
            end case;

            if sreg = x"FFFF" then
                finished <= '1';
            else
                finished <= '0';
            end if;

        end if;
    end process;

end architecture;