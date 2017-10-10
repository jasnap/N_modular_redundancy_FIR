`ifndef FIR_DRIVER
`define FIR_DRIVER

parameter int ORD         = 10;         // Filter order
parameter int DATA_W      = 24;         // Data width
parameter int COEF_ADDR_W = 4;          // Coeff address width

typedef real wram_type[$];

class fir_driver;

  virtual fir_if f_if;
  real input_data[$], coef_data[$], exp_data[$];
  integer i, inst_size;
  // Constructor
  function new(virtual fir_if pins);
     f_if = pins;
  endfunction
/*---- Initialize ----*/
  task initialize();
    $display("Initialize");
     f_if.u_in <= 0;
     f_if.coef_addr_in <= 0;
     f_if.coef_in <= 0;
     f_if.we_in <= 0;
  endtask
  /*------Parse txt file-------*/
  function wram_type parseInput();

	integer fileid = $fopen("fir_matlab/input.txt", "r");
  string l, str;
//bit [23:0] str;
 
  wram_type wram_vector;
  integer i;

  while(!$feof(fileid)) begin
  	l = $fscanf(fileid, "%s", str);
    // $display(str);
	  wram_vector.push_back(str.atobin());
  end
  $fclose(fileid);
  return wram_vector;
  endfunction

function wram_type parseCoefs();

  integer fileid = $fopen("fir_matlab/coef.txt", "r");
  string l, str;
//bit [23:0] str;
 
  wram_type wram_vector;
  integer i;

  while(!$feof(fileid)) begin
    l = $fscanf(fileid, "%s", str);
    // $display(str);
    wram_vector.push_back(str.atobin());
  end
  $fclose(fileid);
  return wram_vector;
  endfunction

function wram_type parseExpected();

  integer fileid = $fopen("fir_matlab/expected.txt", "r");
  string l, str;
  //bit [23:0] str;
   
  wram_type wram_vector;
  integer i;

  while(!$feof(fileid)) begin
    l = $fscanf(fileid, "%s", str);
    // $display(str);
    wram_vector.push_back(str.atoi());
  end
  $fclose(fileid);
  return wram_vector;
  endfunction

  task writeRam(real w_data[], real w_coef[], real exp_data[]);

    int temp, j, i, offset;
    offset = 0;
  for(i = 0; i < w_coef.size() - 1;i++) begin
        @(posedge f_if.clk_i_sig) begin
          f_if.coef_in <= w_coef[i];
          f_if.coef_addr_in <= i;
          f_if.we_in <= 1;
        end
      end
		for(i = 0; i < w_data.size();i++) begin
		  @(posedge f_if.clk_i_sig) begin
  			f_if.u_in <= w_data[i];
        f_if.we_in <= 1;
  		end
		end
    

  endtask

  task run();
  	integer j;
    begin
    	/* Initialization */
       initialize();
    	/* Get instances */
       input_data = parseInput();
	     coef_data = parseCoefs();
	     exp_data = parseExpected();
       $display("Input data");
	     for(j = 0; j < input_data.size(); j++) begin
	    	  $display(input_data[j]);
	     end
       $display(" Writing data to WRAM");
   	   writeRam(input_data, coef_data, exp_data);
       // if(f_if.u_in == exp_data[i])
       //    $display("Data match! %h = %h", f_if.u_in, exp_data[i]);
       //  else 
       //    $display("Data missmatch! %h = %h", f_if.u_in, exp_data[i]);
       #100;

    end

  endtask // run

endclass // fir_driver
`endif
