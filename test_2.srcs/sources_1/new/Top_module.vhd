library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_module is
    Port ( clk_100mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           txd : out STD_LOGIC;
           ready : out STD_LOGIC;
--           mem_addr_out : out STD_LOGIC_VECTOR (13 downto 0);
           idle            : out std_logic);
end Top_module;

architecture Behavioral of Top_module is

signal ready_wire : std_logic;
signal mem_data_in_wire : std_logic_vector(31 downto 0);
signal Data_wire : std_logic_vector(7 downto 0);
signal address_wire : std_logic_vector(13 downto 0);
signal active_wire  : std_logic;

signal wea_wire : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal dataina  : STD_LOGIC_VECTOR(31 DOWNTO 0);

component FSM_new is
  port (
    clk             : in std_logic;
    mem_data_in     : in  std_logic_vector(31 downto 0);
    start           : in std_logic;
    reset           : in std_logic;
    Data            : out  std_logic_vector(7 downto 0);
    mem_addr_out    : out  std_logic_vector(13 downto 0)
    );
end component;

component UART_FSM is
  generic (
    g_CLKS_PER_BIT : integer := 500     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end component;

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;

begin

controller : FSM_new PORT MAP(
clk => clk_100mhz,
mem_data_in => mem_data_in_wire,
start => start,
reset => reset,
Data => Data_wire,
mem_addr_out => address_wire);

UART : UART_FSM PORT MAP(
i_Clk => clk_100mhz,
i_TX_DV => start,
i_TX_Byte => Data_wire,
o_TX_Active => active_wire,
o_TX_Serial => txd,
o_TX_Done => ready_wire);

BRAM : blk_mem_gen_0 PORT MAP(
clka => clk_100mhz,
wea => wea_wire,
addra => address_wire,
dina => dataina,
douta => mem_data_in_wire);

ready <= ready_wire;
idle <= active_wire;
--mem_addr_out <= address_wire;
end Behavioral;
