library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity uart_tb is
end uart_tb;
 
architecture behave of uart_tb is
 
component Top_module is
    Port ( clk_100mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           txd : out STD_LOGIC;
           ready : out STD_LOGIC;
           idle            : out std_logic;
           mem_addr_out : out STD_LOGIC_VECTOR (13 downto 0));
end component;
 
   
  signal r_CLOCK     : std_logic := '0';
  signal r_reset     : std_logic := '0';
  signal r_start : STD_LOGIC := '0';
  signal r_txd : STD_LOGIC;
  signal r_ready : STD_LOGIC;
  signal r_mem_addr_out : STD_LOGIC_VECTOR (13 downto 0);
  signal r_idle : std_logic := '0';
 
   
begin

  UART_TX_INST : Top_module
    port map (
      clk_100mhz       => r_CLOCK,
      reset     => r_reset,
      start => r_start,
      txd => r_txd,
      ready   => r_ready,
      idle => r_idle,
      mem_addr_out => r_mem_addr_out
      );
 
  r_CLOCK <= not r_CLOCK after 5 ns;
   
  process
  begin
 
  wait for 10ms;
  r_start <= '1';
  wait for 10ms;
  r_reset <= '1';
  wait for 2ms;
  r_reset <= '0';
  wait for 10ms;
  r_start <= '0';
  wait for 0.5ms;
  r_start <= '1';
    wait for 1ms;
  r_start <= '0';
    wait for 0.5ms;
  r_start <= '1';

  end process;
   
end behave;