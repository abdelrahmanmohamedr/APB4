////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_driver
////////////////////////////////////////////////////////////////////////////////

package apb_driver;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_sequence_item_pkg::*;                        // Import APB sequence item package
    import apb_config_obj::*;                               // Import APB configuration object package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_driver extends uvm_driver #(apb_sequence_item);

        // Factory registration
        `uvm_component_utils(apb_driver);

        // Virtual interface declaration
        virtual apb_int apb_driver_vif;                     // Virtual interface for APB signals

        // Object declaration
        apb_sequence_item seq_item;                         // Sequence item object

        // Constructor
        function new(string name = "apb_driver", uvm_component parent = null);
            super.new(name, parent);                        // Call parent constructor
        endfunction // new function

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);                       // Call parent build phase
        endfunction // build_phase function

        // Run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);                         // Call parent run phase

            forever begin
                // Object creation
                seq_item = apb_sequence_item::type_id::create("seq_item", this);

                // Start requesting items
                seq_item_port.get_next_item(seq_item);      // Request the next item

                // Assign sequence item values to the virtual interface
                apb_driver_vif.master_in = seq_item.master_in; // Assign master input data
                apb_driver_vif.slave_in = seq_item.slave_in;   // Assign slave input data
                apb_driver_vif.address = seq_item.address;     // Assign address
                apb_driver_vif.process = seq_item.process;     // Assign process control signal
                apb_driver_vif.data_size = seq_item.data_size; // Assign data size
                apb_driver_vif.rst_n = seq_item.rst_n;         // Assign reset signal
                apb_driver_vif.valid = seq_item.valid;         // Assign valid signal

                // Wait for the negative edge of the clock
                @(negedge apb_driver_vif.clk);

                // End the current item
                seq_item_port.item_done();                   // Mark the item as done

                // Log the stimulus details
                `uvm_info("run_phase", seq_item.convert2string_stimulus(), UVM_MEDIUM);

                #0; // Small delay
            end
        endtask // run_phase function

    endclass // apb_driver class

endpackage // apb_driver package