////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_top
////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
import apb_test_pkg::*;
`include "uvm_macros.svh";

module apb_top ();

    // Internal signals
    bit clk;                                               // Clock signal

    // Clock generation
    initial begin
        clk = 0;                                           // Initialize clock to 0
        forever begin
            #20;                                           // Toggle clock every 20 time units
            clk = ~clk;
        end
    end

    // Modules instantiation
    apb_int apbint(clk);                                   // Interface module
    apb_top_design apb_top_design(apbint);                 // Design module

    // UVM instantiation
    initial begin
        uvm_config_db#(virtual apb_int)::set(null, "*", "interface", apbint); // Set virtual interface
        run_test("apb_test");                              // Run the UVM test
    end

endmodule