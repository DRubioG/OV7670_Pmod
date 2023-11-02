library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_controlador is
    port (
        clk : in std_logic;
        resend : in std_logic;
        susp : in std_logic;
        config_finished : out std_logic;
        SIOC : out std_logic;
        SIOD : out std_logic;
        reset : out std_logic;
        pwdn : out std_logic;
        xclk : out std_logic
    );
end entity;

architecture Behavioral of ov7670_controlador is


    component SCCB_registers is
        port (
            clk : in std_logic;
            resend : in std_logic;
            advance : in std_logic;
            command : out std_logic_vector (15 downto 0);
            finished : out std_logic
        );
    end component;

    component SCCB_sender is
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
    end component;

constant camera_address : std_logic_vector(7 downto 0) := x"42";
begin
    config_finished <= finished;
    send <= not finished;

impl_SCCB_sender : SCCB_sender 
        port map (
            clk => clk,
            SIOD => SIOD,
            SIOC => SIOC,
            taken => taken,
            send => send,
            id => id,
            reg => command(15 downto 8),
            value => command (7 downto 0)
        );

        reset <= '1';
        pwdn <= susp;
        xclk <= clk;


impl_SCCB_registers : entity work.SCCB_register
        port map (
            clk => clk,
            resend => resend,
            advance => taken,
            command => command,
            finished => finished
        );
end Behavioral ; -- Behavioral