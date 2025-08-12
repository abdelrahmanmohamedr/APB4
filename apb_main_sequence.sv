////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_main_sequence
////////////////////////////////////////////////////////////////////////////////

package apb_main_sequence_pkg;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_sequence_item_pkg::*;                        // Import APB sequence item package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_main_sequence extends uvm_sequence #(apb_sequence_item);

        // Factory registration
        `uvm_object_utils(apb_main_sequence);

        // Object declaration
        apb_sequence_item seq_item;                         // Sequence item object

        // Constructor
        function new(string name = "apb_main_sequence");
            super.new(name);                                // Call parent constructor
        endfunction // new function

        // Body task
        task body();
            // Sequence randomization
            repeat(900000000) begin
                seq_item = apb_sequence_item::type_id::create("seq_item"); // Create sequence item
                start_item(seq_item);                       // Start the sequence item
                assert (seq_item.randomize());              // Randomize the sequence item
                finish_item(seq_item);                      // Finish the sequence item
            end
        endtask // body task

    endclass // apb_main_sequence class

endpackage // apb_main_sequence_pkg
