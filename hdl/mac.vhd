library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAC is
  generic (
    data_w : natural := 24);
  port (
    clk : in  std_logic;
    u_in   : in  std_logic_vector(data_w-1 downto 0);
    b_in   : in  std_logic_vector(data_w-1 downto 0);
    mac_in : in  std_logic_vector(2*data_w-1 downto 0);
    mac_out : out std_logic_vector(2*data_w-1 downto 0));
end MAC;

architecture Behavioral of MAC is
  signal reg_s : std_logic_vector(2*data_w-1 downto 0) := (others => '0');

begin  -- architecture Behavioral

  process(clk, u_in, b_in, mac_in)
  begin
    if clk'event and clk ='1' then
      reg_s <= mac_in;
    end if;
  end process;

  mac_out <= std_logic_vector(signed(reg_s) + (signed(u_in) * signed(b_in)));

end Behavioral;
