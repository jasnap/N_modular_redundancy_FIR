library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;

entity fault_tolerant_fir is
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
end entity ; -- fault_tolerant_fir

architecture arch of fault_tolerant_fir is

signal fir1_out, fir2_out, fir3_out, fir4_out, fir5_out: std_logic_vector(data_w - 1 downto 0);
signal voter_out: std_logic_vector(data_w - 1 downto 0);

component FIR
  generic (
    order     : natural := 20;
    data_w    : natural := 24);
  port (
    clk          : in  std_logic;
    we_in        : in std_logic;
    coef_addr_in : in std_logic_vector(log2c(order + 1) - 1 downto 0);
    coef_in      : in std_logic_vector(data_w - 1 downto 0);
    u_in         : in std_logic_vector(data_w - 1 downto 0);
    y_out        : out std_logic_vector(data_w - 1 downto 0));

end component;

component VOTER
  generic(
        data_w : natural := 24);
  port ( 
        d1_in: in std_logic_vector(data_W - 1 downto 0);
        d2_in: in std_logic_vector(data_W - 1 downto 0);
        d3_in: in std_logic_vector(data_W - 1 downto 0);
        d4_in: in std_logic_vector(data_W - 1 downto 0);
        d5_in: in std_logic_vector(data_W - 1 downto 0);
        d_out: out std_logic_vector(data_W - 1 downto 0));
end component;

begin

  	FIR_1:FIR generic map(data_w => data_w)
    		  port map(
              	clk     	   => clk,
              	we_in   	   => we_in,
              	coef_addr_in => coef_addr_in,
              	coef_in  	   => coef_in,
              	u_in 		     => u_in,
              	y_out 	  	 => fir1_out);

    FIR_2:FIR generic map(data_w => data_w)
    		  port map(
              	clk     	   => clk,
              	we_in   	   => we_in,
              	coef_addr_in => coef_addr_in,
              	coef_in  	   => coef_in,
              	u_in         => u_in,
              	y_out 	  	 => fir2_out);
  	FIR_3:FIR generic map(data_w => data_w)
    		  port map(
              	clk     	    => clk,
              	we_in   	    => we_in,
              	coef_addr_in  => coef_addr_in,
              	coef_in  	    => coef_in,
              	u_in 		      => u_in,
              	y_out 	  	  => fir3_out);

  	FIR_4:FIR generic map(data_w => data_w)
    		  port map(
              	clk     	    => clk,
              	we_in   	    => we_in,
              	coef_addr_in  => coef_addr_in,
              	coef_in  	    => coef_in,
              	u_in 		      => u_in,
              	y_out 	  	  => fir4_out);

   	
   	FIR_5:FIR generic map(data_w => data_w)
    		  port map(
              	clk     	    => clk,
              	we_in   	    => we_in,
              	coef_addr_in  => coef_addr_in,
              	coef_in  	    => coef_in,
              	u_in 		      => u_in,
              	y_out 	  	  => fir5_out);


   	VOTER1: VOTER generic map(data_w => data_w)
   				  port map(
   				  	d1_in => fir1_out,
   				  	d2_in => fir2_out,
   				  	d3_in => fir3_out,
   				  	d4_in => fir4_out,
   				  	d5_in => fir5_out,
   				  	d_out => voter_out
   				  	);
y_out <= voter_out;
end architecture ; -- arch
