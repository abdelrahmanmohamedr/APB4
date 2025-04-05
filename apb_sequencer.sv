////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_sequencer
////////////////////////////////////////////////////////////////////////////////

package apb_sequencer_pkg;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_sequence_item_pkg::*;                        // Import APB sequence item package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_sequencer extends uvm_sequencer #(apb_sequence_item);

        // Factory registration
        `uvm_component_utils(apb_sequencer);

        // Constructor
        function new(string name = "apb_sequencer", uvm_component parent = null);
            super.new(name, parent);                        // Call parent constructor
        endfunction // new function

    endclass // apb_sequencer class

endpackage // apb_sequencer_pkg