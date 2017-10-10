`ifndef FIR_IF
`define FIR_IF

// Parameters
interface fir_if(input clk_i_sig);
   parameter int ORD         = 10;         // Filter order
   parameter int DATA_W      = 24;         // Data width
   parameter int COEF_ADDR_W = 4;          // Coeff address width

    // Input
   logic [DATA_W-1:0]      u_in;
   logic [COEF_ADDR_W-1:0] coef_addr_in;
   logic [DATA_W-1:0] 	   coef_in;
   logic 				   we_in;

   // Output
   logic [DATA_W-1:0] 	   y_out;

endinterface : fir_if
`endif
