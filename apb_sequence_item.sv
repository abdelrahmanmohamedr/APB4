////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_sequence_item
////////////////////////////////////////////////////////////////////////////////

package apb_sequence_item_pkg;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_sequence_item extends uvm_sequence_item;

        // Factory registration
        `uvm_object_utils(apb_sequence_item);

        // Parameters
        parameter ADDR_WIDTH = 32;                          // Width of the address bus
        parameter DATA_WIDTH = 32;                          // Width of the data bus
        parameter STRB_WIDTH = DATA_WIDTH / 8;              // Byte strobe width

        // Internal signals
            rand logic [DATA_WIDTH-1:0] master_in;                   // Data read from slave
            rand logic [DATA_WIDTH-1:0] slave_in;                    // Data to be written to slave
            rand logic [ADDR_WIDTH-1:0] address;                     // Address for the transaction
            logic [ADDR_WIDTH-1:0] master_out;                  // APB address output
            logic [DATA_WIDTH-1:0] slave_out;                   // Write data output for APB
            rand logic [6:0] process;                                // Process control signal
            rand logic [1:0] data_size;                              // Data size signal
            rand logic rst_n;                                        // Reset (active low)
            rand logic valid;                                        // Valid signal
            logic [DATA_WIDTH-1:0] PWDATA;                          // Write data for slave
            logic [STRB_WIDTH-1:0] PSTRB;                           // Byte strobe signals
            logic [DATA_WIDTH-1:0] PRDATA;                          // Data read from slave
            logic [ADDR_WIDTH-1:0] PADDR;                           // Address for the transaction
            logic [2:0] PPROT;                                      // Protection bits
            logic PSEL1;                                            // Peripheral select 1
            logic PSEL0;                                            // Peripheral select 0
            logic PENABLE;                                          // Enable signal
            logic PWRITE;                                           // Write signal
            logic PREADY;                                           // Ready signal from slave
            bit clk;                                                // Clock signal
            
            

        // Functions

        // Convert the sequence item to a string for debugging
        function string convert2string();
            return $sformatf("%s master_in = 0h%0h, slave_in = 0h%0h, address = 0d%0d, process = 0b%0b, data_size = 0b%0b, valid = 0b%0b, rst_n = 0b%0b, master_out = 0h%0h, slave_out = 0h%0h, 
            PWDATA = 0h%0h, PSTRB = 0b%0b, PRDATA = 0h%0h, PADDR = 0d%0d, PPROT = 0b%0b, PSEL1 = 0b%0b, PSEL0 = 0b%0b, PENABLE = 0b%0b, PWRITE = 0b%0b, PREADY = 0b%0b",
                             super.convert2string(), master_in, slave_in, address, process, data_size, valid, rst_n, master_out, slave_out, PWDATA, PSTRB, PRDATA, PADDR, PPROT, PSEL1, PSEL0, PENABLE, PWRITE, PREADY);
        endfunction // convert2string function

        // Convert the stimulus to a string for debugging
        function string convert2string_stimulus();
            return $sformatf("master_in = 0h%0h, slave_in = 0h%0h, address = 0d%0d, process = 0b%0b, data_size = 0b%0b, valid = 0b%0b, rst_n = 0b%0b",
                             master_in, slave_in, address, process, data_size, valid, rst_n);
        endfunction // convert2string_stimulus function

        // Constraints
        constraint apb_constraints {
            rst_n dist {0:/10, 1:/90};                      // Reset is off 10% and on 90%
            valid dist {0:/10, 1:/90};                      // Valid is off 10% and on 90%
            address dist {4000:/45, 4001:/45, [0:32'hFFFFFFFF]:/10};              // Address distribution
            process dist {7'b0000011:/45, 7'b0100011:/45, [0:7'b1111111]:/10};  // Process distribution
            data_size dist {0:/30, 1:/30, 2:/30};            // Data size distribution
        } // apb_constraints

    endclass // apb_sequence_item class

endpackage // apb_sequence_item_pkg