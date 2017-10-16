 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac is
  generic (
    data_w : natural := 24);
  port (
    clk    : in std_logic;
    u_in   : in std_logic_vector(data_w-1 downto 0);
    b_in   : in std_logic_vector(data_w-1 downto 0);
    fault_ctrl: in std_logic_vector(2 downto 0);
    mac_in : in std_logic_vector(2*data_w-1 downto 0);
    mac_out: out std_logic_vector(2*data_w-1 downto 0));
end mac;

architecture Behavioral of MAC is
  signal reg_s : std_logic_vector(2*data_w-1 downto 0) := (others => '0');
  signal stuck_at1: std_logic_vector(2*data_w-1 downto 0) := (others => '1');
  signal stuck_at0: std_logic_vector(2*data_w-1 downto 0):= (others => '0');
  signal mul_out: signed(2*data_w-1 downto 0);  
begin  -- architecture Behavioral

mul_out <= signed(u_in) * signed(b_in);
  process(clk, u_in, b_in, mac_in)
  begin
    if clk'event and clk ='1' then
        case fault_ctrl is
            when "000" => 
                reg_s <= mac_in;                --no fault
            when "001" => 
                reg_s <= mac_in and stuck_at0;   --reg_s stuck at 0
            when "010" =>
                reg_s <= mac_in or stuck_at1;   --reg_s stuck at 1
            when others => null;
        end case;
    end if;
  end process;

  mac_out <= std_logic_vector(signed(reg_s) + mul_out);

end Behavioral;

