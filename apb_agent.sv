////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_agent
////////////////////////////////////////////////////////////////////////////////

package apb_agent_pkg;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_sequencer_pkg::*;                            // Import APB sequencer package
    import apb_monitor_pkg::*;                              // Import APB monitor package
    import apb_driver::*;                                   // Import APB driver package
    import apb_config_obj::*;                               // Import APB configuration object package
    import apb_sequence_item_pkg::*;                        // Import APB sequence item package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_agent extends uvm_agent;

        // Factory registration
        `uvm_component_utils(apb_agent);

        // Object declarations
        apb_driver driver;                                  // APB driver
        apb_sequencer sequencer;                            // APB sequencer
        apb_monitor monitor;                                // APB monitor
        apb_config_obj apb_config_obj_agent;                // APB configuration object

        // Analysis port declaration
        uvm_analysis_port #(apb_sequence_item) agent_p;     // Analysis port for broadcasting sequence items

        // Constructor
        function new(string name = "apb_agent", uvm_component parent = null);
            super.new(name, parent);                        // Call parent constructor
        endfunction // new function

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);                       // Call parent build phase

            // Agent port creation
            agent_p = new("agent_p", this);                 // Create analysis port

            // Create objects
            driver = apb_driver::type_id::create("driver", this); // Create APB driver
            monitor = apb_monitor::type_id::create("monitor", this); // Create APB monitor
            sequencer = apb_sequencer::type_id::create("sequencer", this); // Create APB sequencer
            apb_config_obj_agent = apb_config_obj::type_id::create("apb_config_obj_agent", this); // Create configuration object

            // Get the configuration object (interface)
            uvm_config_db#(apb_config_obj)::get(this, "", "interface_test", apb_config_obj_agent);
        endfunction // build_phase function

        // Connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);                     // Call parent connect phase

            // TLM port-export connection
            driver.seq_item_port.connect(sequencer.seq_item_export); // Connect driver to sequencer

            // Interface connection
            driver.apb_driver_vif = apb_config_obj_agent.apb_config_vif; // Connect driver to virtual interface
            monitor.apb_monitor_vif = apb_config_obj_agent.apb_config_vif; // Connect monitor to virtual interface

            // TLM analysis port-port connection
            monitor.mon_p.connect(agent_p);                 // Connect monitor analysis port to agent analysis port
        endfunction // connect_phase function

    endclass // apb_agent class

endpackage // apb_agent package