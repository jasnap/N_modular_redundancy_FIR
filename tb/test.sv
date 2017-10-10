program test (fir_if f);

  //declaring environment instance
  fir_env env;
  initial begin
  	env = new(f);
    $display(" ");
    $display("Test is running");

    env.run_all();

    $display("Test is finished!");
    $display(" ");
  end

endprogram
