////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_env
////////////////////////////////////////////////////////////////////////////////

package apb_env;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_agent_pkg::*;                                // Import APB agent package
    import apb_scoreboard_pkg::*;                           // Import APB scoreboard package
    import apb_coverage_pkg::*;                             // Import APB coverage package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_env extends uvm_env;

        // Factory registration
        `uvm_component_utils(apb_env);

        // Object declarations
        apb_agent agent;                                    // APB agent
        apb_scoreboare sb;                                  // APB scoreboard
        apb_coverge cov;                                    // APB coverage

        // Constructor
        function new(string name = "apb_env", uvm_component parent = null);
            super.new(name, parent);                        // Call parent constructor
        endfunction // new function

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);                       // Call parent build phase

            // Create objects
            agent = apb_agent::type_id::create("agent", this); // Create APB agent
            sb = apb_scoreboare::type_id::create("sb", this); // Create APB scoreboard
            cov = apb_coverge::type_id::create("cov", this);  // Create APB coverage
        endfunction // build_phase function

        // Connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);                     // Call parent connect phase

            // TLM analysis port-export connection
            agent.agent_p.connect(sb.sb_exp);               // Connect agent analysis port to scoreboard export
            agent.agent_p.connect(cov.cov_exp);             // Connect agent analysis port to coverage export
        endfunction // connect_phase function

    endclass // apb_env class

endpackage // apb_env package