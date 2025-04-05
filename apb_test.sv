////////////////////////////////////////////////////////////////////////////////
// Name: Abdelrahman Mohamed
// Module-Name: apb_test
////////////////////////////////////////////////////////////////////////////////

package apb_test_pkg;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_env::*;                                      // Import APB environment package
    import apb_config_obj::*;                               // Import APB configuration object package
    import apb_main_sequence_pkg::*;                        // Import APB main sequence package
    import apb_rst_sequence_pkg::*;                         // Import APB reset sequence package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_test extends uvm_test;

        // Factory registration
        `uvm_component_utils(apb_test);

        // Object declarations
        apb_env env;                                        // APB environment
        apb_config_obj apb_config_obj_test;                 // APB configuration object
        apb_main_sequence main_sequence;                    // APB main sequence
        apb_rst_sequence reset_sequence;                    // APB reset sequence

        // Constructor
        function new(string name = "apb_test", uvm_component parent = null);
            super.new(name, parent);                        // Call parent constructor
        endfunction // new function

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);                       // Call parent build phase

            // Object creation
            env = apb_env::type_id::create("env", this);    // Create APB environment
            main_sequence = apb_main_sequence::type_id::create("main_sequence"); // Create main sequence
            reset_sequence = apb_rst_sequence::type_id::create("reset_sequence"); // Create reset sequence
            apb_config_obj_test = apb_config_obj::type_id::create("apb_config_obj_test", this); // Create configuration object

            // Get the interface from the top
            uvm_config_db#(virtual apb_int)::get(this, "", "interface", apb_config_obj_test.apb_config_vif);

            // Set the configuration object
            uvm_config_db#(apb_config_obj)::set(this, "*", "interface_test", apb_config_obj_test);
        endfunction // build_phase function

        // Run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);                         // Call parent run phase
            phase.raise_objection(this);                    // Raise objection to keep the simulation running

            // Start the reset sequence
            reset_sequence.start(env.agent.sequencer);      // Start reset sequence driving
            `uvm_info("run_phase", "Finish first test", UVM_MEDIUM);

            // Start the main sequence
            main_sequence.start(env.agent.sequencer);       // Start main sequence driving
            `uvm_info("run_phase", "Finish second test", UVM_MEDIUM);

            phase.drop_objection(this);                     // Drop objection to end the simulation
        endtask // run_phase task

    endclass // apb_test class

endpackage // apb_test_pkg