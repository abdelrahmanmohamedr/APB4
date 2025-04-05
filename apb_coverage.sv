////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_coverge
////////////////////////////////////////////////////////////////////////////////

package apb_coverage_pkg;

    // Package imports
    import uvm_pkg::*;                                      // Import UVM package
    import apb_sequence_item_pkg::*;                        // Import APB sequence item package
    `include "uvm_macros.svh";                              // Include UVM macros

    // Class definition
    class apb_coverge extends uvm_component;

        // Factory registration
        `uvm_component_utils(apb_coverge);

        // Object declaration
        apb_sequence_item seq_item;                         // Sequence item object

        // TLM analysis export declaration
        uvm_analysis_export #(apb_sequence_item) cov_exp;   // Analysis export for coverage
        uvm_tlm_analysis_fifo #(apb_sequence_item) cov_apb;  // TLM analysis for APB

        // Covergroup declaration
        covergroup apb_coverage;

            // Valid signal coverage
            valid: coverpoint seq_item.valid {
                bins valid = {1};                          // Valid signal is high
                bins invalid = {0};                        // Valid signal is low
            }

            // Reset signal coverage
            rst_n: coverpoint seq_item.rst_n {
                bins reset = {0};                          // Reset signal is active
                bins no_reset = {1};                       // Reset signal is inactive
            }

            // Address signal coverage
            address: coverpoint seq_item.address {
                bins slave_0 = {4000};                        // Address for slave 0
                bins slave_1 = {4001};                        // Address for slave 1
                bins others = default;                        // Other addresses   
            }

            // Process signal coverage
            process: coverpoint seq_item.process {
                bins load = {7'b0000011};                     // Load operation
                bins store = {7'b0100011};                    // Store operation
                bins others = default;                     // Other instructions   
            }

            // Data size signal coverage
            data_size: coverpoint seq_item.data_size {
                bins byte_ = {0};                          // Byte data size
                bins half_word = {1};                      // Half-word data size
                bins word = {2};                           // Word data size
            }

            // Cross coverage
            cross valid, rst_n;                             // Cross coverage for valid and reset signals
            cross address, process;                         // Cross coverage for address and process signals

        endgroup // apb_coverage covergroup

        // Constructor
        function new(string name = "apb_coverge", uvm_component parent = null);
            super.new(name, parent);                        // Call parent constructor
            apb_coverage = new();                           // Initialize covergroup
        endfunction // new function

        // Build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);                       // Call parent build phase
            cov_exp = new("cov_exp", this);                 // Create analysis export
            cov_apb = new("cov_apb", this);                 // Create TLM analysis
        endfunction // build_phase function

        // Connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);                     // Call parent connect phase
            cov_exp.connect(cov_apb.analysis_export);       // Connect analysis export to TLM analysis
        endfunction // connect_phase function

        // Run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);                         // Call parent run phase
            forever begin
                cov_apb.get(seq_item);                      // Get sequence item from TLM analysis
                apb_coverage.sample();                      // Sample the covergroup
            end
        endtask // run_phase task

    endclass // apb_coverge class

endpackage // apb_coverage_pkg