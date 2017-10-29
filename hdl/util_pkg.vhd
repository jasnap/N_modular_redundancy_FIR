library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

package util_pkg is
  function log2c(n:integer) return integer;
  function to_std_logic(ch: character) return std_logic;
  function to_std_logic_vector(st: string) return std_logic_vector;
end util_pkg;

package body util_pkg is
	function log2c(n:integer) return integer is
		variable m,p:integer;
	begin
	m:=0;
	p:=1;
	while p<n loop
		m := m + 1;
		p := p * 2;
	end loop;
	return m;
	end log2c;
    function to_std_logic(ch: character) return std_logic is
      variable str_l: std_logic;
    begin
      case ch is
        when '0' =>
          str_l := '0';
        when '1' =>
          str_l := '1';
        when others =>
          str_l := 'X';
      end case;
      return str_l;
    end to_std_logic;

    function to_std_logic_vector(st: string) return std_logic_vector is
      variable st_l: std_logic_vector(st'high-st'low downto 0);
      variable j: integer;
    begin
      j := st'high-st'low;
      for i in st'range loop
        st_l(j) := to_std_logic(st(i));
        j := j - 1;
      end loop;
      return st_l;
    end to_std_logic_vector;

end util_pkg;
