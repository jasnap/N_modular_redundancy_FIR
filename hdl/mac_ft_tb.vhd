library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac_tb is
generic (
   data_w : natural := 24);
end mac_tb;

architecture mac_tb_arc of mac_tb is
   signal clk: std_logic := '1';
   signal u_in, b_in: std_logic_vector(data_w - 1 downto 0);
   signal mac_in, mac_out: std_logic_vector(2*data_w - 1 downto 0);
   signal fault_ctrl : std_logic_vector(2 downto 0);
   
   type data_reg is array (natural range <>) of std_logic_vector(data_w - 1 downto 0);
   type data1_reg is array (natural range <>) of std_logic_vector(2*data_w - 1 downto 0);
   signal b_in_s, u_in_s : data_reg(3 downto 0);
   signal data_in_reg : data1_reg(9 downto 0);
   
begin

   DUT: entity work.mac
       generic map(
           data_w => data_w)
         port map(
           clk        => clk,
           u_in          => u_in,
           b_in         => b_in,
           fault_ctrl => fault_ctrl,
           mac_in       => mac_in,
           mac_out    => mac_out);

    b_in_s <= ("000000000000000000000000",
               "111111111111111111111111",
               "000000000000000000000000",
               "111111111111111111111111");
               
	u_in_s <= ("000000000000000000000000",
	           "000000000000000000000000",
	           "111111111111111111111111",
	           "111111111111111111111111");

   	data_in_reg <= ("000000000000000000000000111111111100110110010110",
                    "000000000000000000000000000000000000000000000000",
                    "000000000000000000000000111111111110011011001011",
                    "000000000000000000000000111111100110000000011001",
                    "000000000000000000000000000000000111111000001000",
                    "000000000000000000000000111111110000001111110000",
                    "000000000000000000000000111111101000010111101000",
                    "000000000000000000000000000000001001011100111101",
                    "000000000000000000000000111111011100100011011101",
                    "000000000000000000000000000000001001011111111101");
   
   clk <= not clk after 10 ns;
   fault_ctrl <= "110";
   
   tb: process
   begin
       wait until clk = '1';
    
       for i in 0 to 3 loop
           b_in <= b_in_s(i);
           u_in <= u_in_s(i);    
           wait until clk = '1';
       end loop;
       for i in 0 to 3 loop 
           mac_in <= data_in_reg(i);
           wait until clk = '1';
       end loop;
   end process tb;
end mac_tb_arc;
