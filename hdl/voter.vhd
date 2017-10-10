library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VOTER is
  generic(
        data_w : natural := 24);
  port ( 
        d1_in: in std_logic_vector(data_W - 1 downto 0);
        d2_in: in std_logic_vector(data_W - 1 downto 0);
        d3_in: in std_logic_vector(data_W - 1 downto 0);
        d4_in: in std_logic_vector(data_W - 1 downto 0);
        d5_in: in std_logic_vector(data_W - 1 downto 0);
        d_out: out std_logic_vector(data_W - 1 downto 0));
end VOTER;

architecture Behavioral of VOTER is

begin

    d_out <= ((d1_in and d2_in and d3_in) or (d1_in and d2_in and d4_in) or (d1_in and d3_in and d4_in) or 
              (d2_in and d3_in and d4_in) or (d1_in and d2_in and d5_in) or (d1_in and d4_in and d5_in) or 
              (d1_in and d3_in and d5_in) or (d2_in and d3_in and d5_in) or (d3_in and d4_in and d5_in) or 
              (d2_in and d4_in and d5_in));

end Behavioral;