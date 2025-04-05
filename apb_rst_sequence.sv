////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_rst_sequence
////////////////////////////////////////////////////////////////////////////////

package apb_rst_sequence_pkg;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_sequence_item_pkg::*;                        // Import APB sequence item package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_rst_sequence extends uvm_sequence #(apb_sequence_item);

        // Factory registration
        `uvm_object_utils(apb_rst_sequence);

        // Object declaration
        apb_sequence_item seq_item;                         // Sequence item object

        // Constructor
        function new(string name = "apb_rst_sequence");
            super.new(name);                                // Call parent constructor
        endfunction // new function

        // Body task
        task body();
            // Sequence randomization
            seq_item = apb_sequence_item::type_id::create("seq_item"); // Create sequence item
            start_item(seq_item);                           // Start the sequence item
            seq_item.rst_n = 0;                             // Set reset signal to 0
            finish_item(seq_item);                          // Finish the sequence item
        endtask // body task

    endclass // apb_rst_sequence class

endpackage // apb_rst_sequence_pkg