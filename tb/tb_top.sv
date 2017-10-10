module tb_top;

  //clock and rst signal declaration
  reg clk;

  // creating instance of the interface
  fir_if f_if(clk);

  //test
  test t1(f_if);

  // DUT
  fault_tolerant_fir DUT(
         .u_in               (f_if.u_in),
         .coef_addr_in       (f_if.coef_addr_in),
         .coef_in            (f_if.coef_in),
         .we_in              (f_if.we_in),
         .clk                (f_if.clk_i_sig),
         .y_out              (f_if.y_out));

  //clock generation
  always
  	begin
  	clk <= 0;
  	#5
  	clk <= ~clk;
  	#5;
  end

  //rst Generation
  //initial begin
    //$display("Starting...");
    //rst <= 1;
    //#20 rst <=0;
  //end
endmodule
