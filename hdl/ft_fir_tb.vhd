library ieee, modelsim_lib;
use ieee.std_logic_1164.all;
use modelsim_lib.util.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.util_pkg.all;

entity ft_fir_tb is
    generic(data_w : natural := 24;
        order  : natural := 10
        );
end ft_fir_tb;

architecture Behavioral of ft_fir_tb is
	constant period : time := 20 ns;
	signal     clk 			: std_logic := '1';
    signal     we_in          : std_logic;
    signal     coef_addr_in : std_logic_vector(log2c(order) - 1 downto 0);
    signal     coef_in         : std_logic_vector(data_w - 1 downto 0);
    signal     u_in           : std_logic_vector(data_w - 1 downto 0);
    signal     y_out           : std_logic_vector(data_w - 1 downto 0);
    type       data_reg is array (natural range <>) of std_logic_vector(data_w - 1 downto 0);
    signal has_checks : std_logic := '0';
    -- open octave files
    file input_oct: text open read_mode is "/home/jasna/Documents/projects/N_modular_redundancy_FIR/fir_matlab/input.txt";
    file coef_oct: text open read_mode is "/home/jasna/Documents/projects/N_modular_redundancy_FIR/fir_matlab/coef.txt";
    file expected_oct: text open read_mode is "/home/jasna/Documents/projects/N_modular_redundancy_FIR/fir_matlab/expected.txt";

begin

DUT : entity work.fault_tolerant_fir
	  	generic map(
   		 		order 	=> order,
    			data_w 	=> data_w)
		port map(
				clk 		 => clk,
				we_in  		 => we_in,
				coef_addr_in => coef_addr_in,
				coef_in 	 => coef_in,
				u_in		 => u_in,
				y_out 		 => y_out
				);
clk_proc: process
begin
  clk <= '0';
  wait for period/2;
  clk <= '1';
  wait for period/2;
end process;


WaveGenProc: process
  variable file_line: line;

  variable st_ln: string(1 to 24);
     begin
       u_in <= (others => '0');
       wait until falling_edge(clk);
       for i in 0 to order loop
         we_in <= '1';
         signal_force("ft_fir_tb/DUT/FIR_1/y_out", "000000000000000000000000", 0 ns, freeze, open, 1);
         signal_force("ft_fir_tb/DUT/FIR_3/y_out", "000000000000000000000000", 0 ns, freeze, open, 1);
         coef_addr_in <= std_logic_vector(to_unsigned(i, log2c(order)));
         readline(coef_oct, file_line);
         st_ln := (others => ' ');
         read(file_line, st_ln(1 to file_line'length));
         coef_in <= to_std_logic_vector(st_ln);
         wait until falling_edge(clk);
       end loop;

       while not endfile(input_oct) loop
         readline(input_oct, file_line);
         st_ln := (others => ' ');
         read(file_line, st_ln(1 to file_line'length));
         u_in <= to_std_logic_vector(st_ln);
         wait until falling_edge(clk);
         has_checks <= '1';
       end loop;
       has_checks <= '0';
     end process WaveGenProc;

  ResultCheckingProc: process
    variable check_line: line;
    variable temp:std_logic_vector(data_w-1 downto 0);
    variable st_ln:string(1 to 24);
  begin
    wait until has_checks = '1';
    while not endfile(expected_oct) loop
      wait until rising_edge(clk);
      readline(expected_oct, check_line);
      st_ln := (others => ' ');
      read(check_line, st_ln(1 to check_line'length));
      temp:=to_std_logic_vector(st_ln);
      if(abs(signed(temp)) - abs(signed(y_out)) > "000000000000000000000111") then
        report "result mismatch" severity failure;
      end if;
    end loop;
  end process;

end Behavioral;
