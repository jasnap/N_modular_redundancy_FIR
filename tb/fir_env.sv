`ifndef FIR_ENV
`define FIR_ENV

class fir_env;

  // Declare classes for driver, stimgen etc...
  fir_driver driver;

  // Virtual interface instance
  virtual fir_if f_if;

  // Constructor
  function new(virtual fir_if f);
	 f_if = f;
	 driver = new(f);
  endfunction

  task run_all();
	begin
   	driver.run();
		$finish;
	end
  endtask // run_all

endclass
`endif


