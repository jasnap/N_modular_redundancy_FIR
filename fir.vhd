library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;

entity FIR is
  generic (
    order     : natural := 10;
    data_w  : natural := 24
    );
  port (
    clk          : in  std_logic;
    we_in        : in std_logic;
    coef_addr_in : in std_logic_vector(log2c(order + 1) - 1 downto 0);
    coef_in      : in std_logic_vector(data_w - 1 downto 0);
    u_in         : in std_logic_vector(data_w - 1 downto 0);
    y_out        : out std_logic_vector(data_w - 1 downto 0));

end FIR;

architecture Behavioral of FIR is

  type data_array is array (order downto 0) of std_logic_vector(2*data_w - 1 downto 0);
  signal data_reg : data_array;
  type coef_array is array (order downto 0) of std_logic_vector(data_w - 1 downto 0);
  signal b_s : coef_array;

  component MAC
    generic (
      data_w : natural);
    port (
      clk     : in  std_logic;
      u_in    : in  std_logic_vector(data_w-1 downto 0);
      b_in    : in  std_logic_vector(data_w-1 downto 0);
      mac_in  : in  std_logic_vector(2*data_w-1 downto 0);
      mac_out : out std_logic_vector(2*data_w-1 downto 0));
  end component;

begin  -- architecture Behavioral

  process(clk)
  begin
    if clk'event and clk = '1' then
      if we_in = '1' then
        b_s(to_integer(unsigned(coef_addr_in))) <= coef_in; --get filter coefs
      end if;
    end if;
  end process;

  MAC0:MAC generic map(data_w => data_w)
    port map(clk     => clk,
             u_in    => u_in,
             b_in    => b_s(order),
             mac_in  => (others => '0'),
             mac_out => data_reg(0));

  MAC_OTHERS:
  for i in 1 to order-1 generate
  MAC_X:MAC generic map(data_w => data_w)
    port map(
              clk     => clk,
              u_in    => u_in,
              b_in    => b_s(order-i),
              mac_in  => data_reg(i-1),
              mac_out => data_reg(i));
  end generate;

  process(clk)
  begin
      if(clk'event and clk='1')then
          y_out <= data_reg(order-1)(2*data_w-1 downto data_w);
      end if;
  end process;
end Behavioral;
