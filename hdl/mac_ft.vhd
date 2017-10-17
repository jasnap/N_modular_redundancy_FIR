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
  signal mul_out: unsigned(2*data_w-1 downto 0);  
begin  -- architecture Behavioral

  process(clk)
  
  begin
    if clk'event and clk ='1' then
        case fault_ctrl is
            when "000" => 
                reg_s <= mac_in;                --no fault
                mul_out <= unsigned(u_in) * unsigned(b_in);
            when "001" => 
                reg_s <= mac_in and stuck_at0;   --reg_s stuck at 0
                mul_out <= unsigned(u_in) * unsigned(b_in);
            when "010" =>
                reg_s <= mac_in or stuck_at1;   --reg_s stuck at 1
                mul_out <= unsigned(u_in) * unsigned(b_in);
            when "011" => 
                mul_out <= unsigned(stuck_at0); --mul_out stuck at 0
                reg_s <= mac_in;
            when "100" =>
                mul_out <= unsigned(stuck_at1); --mul_out stuck at 0
                reg_s <= mac_in;
            when "101" => 
                mul_out <= unsigned(stuck_at0); --mac_out stuck at 0
                reg_s <= mac_in and stuck_at0;
            when "110" => 
                mul_out <= unsigned(stuck_at1); --mac_out stuck at 1
                reg_s <= mac_in or stuck_at1;
            when others => null;
        end case;
    end if;
    
  end process;

  mac_out <= std_logic_vector(unsigned(reg_s) + mul_out);

end Behavioral;