////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_monitor
////////////////////////////////////////////////////////////////////////////////

package apb_monitor_pkg;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_sequence_item_pkg::*;                        // Import APB sequence item package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_monitor extends uvm_monitor;

        // Factory registration
        `uvm_component_utils(apb_monitor)

        // Virtual interface declaration
        virtual apb_int apb_monitor_vif;                    // Virtual interface for APB signals

        // Object declaration
        apb_sequence_item seq_item;                         // Sequence item object

        // TLM analysis port declaration
        uvm_analysis_port #(apb_sequence_item) mon_p;       // Analysis port for broadcasting sequence items

        // Constructor
        function new(string name = "apb_monitor", uvm_component parent = null);
            super.new(name, parent);                        // Call parent constructor
        endfunction // new function

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);                       // Call parent build phase
            mon_p = new("mon_p", this);                     // Create analysis port
        endfunction // build_phase function

        // Run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);                         // Call parent run phase

            forever begin
                // Object creation
                seq_item = apb_sequence_item::type_id::create("seq_item", this);

                // Assigning the value of the interface to the sequence item object
                @(negedge apb_monitor_vif.clk);
                seq_item.master_in = apb_monitor_vif.master_in;   // Capture master input data
                seq_item.slave_in = apb_monitor_vif.slave_in;     // Capture slave input data
                seq_item.address = apb_monitor_vif.address;       // Capture address
                seq_item.master_out = apb_monitor_vif.master_out; // Capture master output data
                seq_item.slave_out = apb_monitor_vif.slave_out;   // Capture slave output data
                seq_item.process = apb_monitor_vif.process;       // Capture process control signal
                seq_item.data_size = apb_monitor_vif.data_size;   // Capture data size
                seq_item.rst_n = apb_monitor_vif.rst_n;           // Capture reset signal
                seq_item.valid = apb_monitor_vif.valid;           // Capture valid signal
                seq_item.PWDATA = apb_monitor_vif.PWDATA;         // Capture write data for slave
                seq_item.PSTRB = apb_monitor_vif.PSTRB;           // Capture byte strobe signals
                seq_item.PRDATA = apb_monitor_vif.PRDATA;         // Capture data read from slave
                seq_item.PADDR = apb_monitor_vif.PADDR;           // Capture address for the transaction
                seq_item.PPROT = apb_monitor_vif.PPROT;           // Capture protection bits
                seq_item.PSEL1 = apb_monitor_vif.PSEL1;           // Capture peripheral select 1
                seq_item.PSEL0 = apb_monitor_vif.PSEL0;           // Capture peripheral select 0
                seq_item.PENABLE = apb_monitor_vif.PENABLE;       // Capture enable signal
                seq_item.PWRITE = apb_monitor_vif.PWRITE;         // Capture write signal
                seq_item.PREADY = apb_monitor_vif.PREADY;         // Capture ready signal from slave
                seq_item.clk = apb_monitor_vif.clk;               // Capture clock signal

                // Broadcasting the sequence item object
                mon_p.write(seq_item);                            // Write sequence item to analysis port
                `uvm_info("run_phase", seq_item.convert2string(), UVM_MEDIUM); // Log sequence item details
            end
        endtask // run_phase function

    endclass // apb_monitor class

endpackage // apb_monitor_pkg