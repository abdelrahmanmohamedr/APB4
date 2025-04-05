////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_config_obj
////////////////////////////////////////////////////////////////////////////////

package apb_config_obj;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_config_obj extends uvm_object;

        // Factory registration
        `uvm_object_utils(apb_config_obj);

        // Virtual interface declaration
        virtual apb_int apb_config_vif;                     // Virtual interface for APB signals

        // Constructor
        function new(string name = "apb_config_obj");
            super.new(name);                                // Call parent constructor
        endfunction // new function

    endclass // apb_config_obj class

endpackage // apb_config_obj package