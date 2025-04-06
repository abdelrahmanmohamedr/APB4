////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_scoreboard
////////////////////////////////////////////////////////////////////////////////

package apb_scoreboard_pkg;

    // Import required packages
    import uvm_pkg::*;                                      // UVM library
    import apb_sequence_item_pkg::*;                        // APB sequence item definitions
    `include "uvm_macros.svh";                              // UVM macro definitions

    // Scoreboard class definition
    class apb_scoreboare extends uvm_scoreboard;

        // Register the scoreboard with the UVM factory
        `uvm_component_utils(apb_scoreboare);

        // Parameter definitions for APB interface properties
        parameter ADDR_WIDTH = 32;                          // Address bus width
        parameter DATA_WIDTH = 32;                          // Data bus width
        parameter STRB_WIDTH = DATA_WIDTH / 8;              // Width of byte strobe signals
        parameter IDLE_PHASE = 2'b00;                       // Identifier for the Idle state
        parameter SETUP_PHASE = 2'b01;                      // Identifier for the Setup state
        parameter ACCESS_PHASE = 2'b10;                     // Identifier for the Access state

        // Internal signal declarations representing APB interface signals
        logic [ADDR_WIDTH-1:0] master_out_ref;              // Reference for master output
        logic [DATA_WIDTH-1:0] slave_out_ref;               // Reference for slave write data
        logic [DATA_WIDTH-1:0] PRDATA_ref;                  // Reference for slave read data
        logic [ADDR_WIDTH-1:0] PADDR_ref;                   // Reference for transaction address
        logic [DATA_WIDTH-1:0] PWDATA_ref;                  // Reference for data to be written to slave
        logic [STRB_WIDTH-1:0] PSTRB_ref;                   // Reference for byte strobe signals
        logic [2:0] PPROT_ref;                              // Reference for protection bits
        logic PSEL1_ref;                                    // Reference for peripheral select signal 1
        logic PSEL0_ref;                                    // Reference for peripheral select signal 0
        logic PENABLE_ref;                                  // Reference for the enable signal
        logic PWRITE_ref;                                   // Reference for the write control signal
        logic PREADY_ref;                                   // Reference for slave ready signal
        logic end_access;                                   // Signal to indicate end of access phase
        logic setup_rst_ideal;                              // Signal to indicate reset during setup phase

        // State machine variables for transaction phases
        logic [1:0] current_state;                          // Current FSM state
        logic [1:0] next_state;                             // Next FSM state

        // Counters for tracking transaction matches
        int right_count = 0;                                // Count of matching transactions (golden reference)
        int wrong_count = 0;                                // Count of mismatches detected

        // Object declaration for APB sequence item transactions
        apb_sequence_item seq_item;

        // TLM export declarations for analysis transactions
        uvm_analysis_export #(apb_sequence_item) sb_exp;
        uvm_tlm_analysis_fifo #(apb_sequence_item) sb_apb;

        // Constructor
        function new(string name = "apb_scoreboare", uvm_component parent = null);
            super.new(name, parent);
        endfunction // new

        // Build phase: Create analysis exports and FIFOs
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_exp = new("sb_exp", this);                 // Instantiate analysis export for APB transactions
            sb_apb = new("sb_apb", this);                 // Instantiate TLM FIFO for APB transactions
        endfunction // build_phase

        // Connect phase: Connect analysis export to TLM FIFO
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_exp.connect(sb_apb.analysis_export);       // Connect export to the analysis FIFO's export
        endfunction // connect_phase

        // Run phase: Process incoming transactions and compare with golden reference
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_apb.get(seq_item);                    // Receive sequence item from the monitor
                golden_ref(seq_item);                    // Update golden reference based on received item

                // Compare DUT output with the golden reference signals
                if ((master_out_ref === seq_item.master_out) &&
                    (slave_out_ref === seq_item.slave_out) &&
                    (PRDATA_ref === seq_item.PRDATA) &&
                    (PADDR_ref === seq_item.PADDR) &&
                    (PWDATA_ref === seq_item.PWDATA) &&
                    (PSTRB_ref === seq_item.PSTRB) &&
                    (PPROT_ref === seq_item.PPROT) &&
                    (PSEL1_ref === seq_item.PSEL1) &&
                    (PSEL0_ref === seq_item.PSEL0) &&
                    (PENABLE_ref === seq_item.PENABLE) &&
                    (PWRITE_ref === seq_item.PWRITE) &&
                    (PREADY_ref === seq_item.PREADY)) begin
                        right_count++;                 // Increment match counter
                    `uvm_info("run_phase", $sformatf("Golden reference matches the DUT output, right_count = %0d, wrong_count = %0d, time = %0t", right_count,wrong_count,$time), UVM_MEDIUM);
                end else begin
                    wrong_count++;                    // Increment mismatch counter
                    `uvm_error("run_phase", $sformatf("Mismatch detected: master_out_ref = %0h, slave_out_ref = %0h, PRDATA_ref = %0h, PADDR_ref = %0d, PWDATA_ref = %0h,PSTRB_ref = %0b, PPROT_ref = %0b, PSEL0_ref = %0b, PSEL1_ref = %0b, PENABLE_ref = %0b, PWRITE_ref = %0b, PREADY_ref = %0b, right_count = %0d, wrong_count = %0d, time = %0t",
                                                     master_out_ref, slave_out_ref, PRDATA_ref, PADDR_ref, PWDATA_ref, PSTRB_ref, PPROT_ref, PSEL0_ref, PSEL1_ref, PENABLE_ref, PWRITE_ref, PREADY_ref, right_count, wrong_count, $time));
                end
            end
        endtask // run_phase

        // Golden reference function: Update expected signal values based on transaction data
        function void golden_ref(apb_sequence_item seq_item);

            // If reset is asserted, clear outputs and return to IDLE state
            if (!seq_item.rst_n) begin
                master_out_ref = 0;                      // Clear master output reference
                slave_out_ref = 0;                       // Clear slave output reference
                PRDATA_ref = 0;
                if (current_state == SETUP_PHASE) begin
                    setup_rst_ideal = 1;                 // Indicate reset during setup
                end
                current_state = IDLE_PHASE;              // Reset FSM to IDLE state
            end
            else begin
                // State machine transitions for APB transaction phases
                case (current_state)
                    IDLE_PHASE: begin
                        ideal_phase();                     // Call ideal phase function
                        if (seq_item.process == (7'b0000011) || seq_item.process == (7'b0100011)) begin
                            current_state = SETUP_PHASE;  // Transition to SETUP phase for valid operations
                        end else begin
                            current_state = IDLE_PHASE;   // Remain in IDLE state
                        end
                    end
                    SETUP_PHASE: begin
                        if (!PSEL0_ref && !PSEL1_ref) begin
                            current_state = IDLE_PHASE;                 // Transition to ACCESS
                        end else begin
                            current_state = ACCESS_PHASE;               // Transition to ACCESS
                        end
                    end
                    ACCESS_PHASE: begin
                        access_phase();                     // Call access phase function
                        if (PREADY_ref && ((seq_item.process == (7'b0000011)) || (seq_item.process == (7'b0100011)))) begin
                            current_state = SETUP_PHASE;  // Transition to SETUP phase when ready
                            end_access = 1;            // Signal end of access
                        end else if (PREADY_ref) begin
                            current_state = IDLE_PHASE;   // Transition back to IDLE state when ready
                            end_access = 1;            // Signal end of access
                        end else begin
                            current_state = ACCESS_PHASE; // Remain in ACCESS phase
                        end
                    end 
                    default: current_state = 3;    // Default to IDLE state
                endcase
            end

            // Ensure correct phase functions are called based on current state
            case (current_state)
                IDLE_PHASE: begin
                    ideal_phase();                     // Call idle phase function
                end
                SETUP_PHASE: begin
                   setup_phase();                      // Call setup phase function
                end
                ACCESS_PHASE: begin
                    access_phase();                     // Call access phase function 
                end
                default: begin
                    PADDR_ref = 0;                     // Clear address reference
                    PWDATA_ref = 0;                    // Clear write data reference
                    PSTRB_ref = 0;                     // Clear strobe reference
                    PPROT_ref = 0;                     // Clear protection bits reference
                    PSEL1_ref = 0;                     // Deassert peripheral select 1
                    PSEL0_ref = 0;                     // Deassert peripheral select 0
                    PENABLE_ref = 0;                   // Clear enable signal
                    PWRITE_ref = 0;                    // Clear write control signal
                end
            endcase
          
        endfunction // golden_ref

        // Ideal phase function: Manage idle state activities and initial signal setup
        function ideal_phase;
        access_end_transition(); // Call function to handle access setup transition
            // Finalize idle phase signals
            end_access = 0;                           // Clear end access signal
            PSEL0_ref = 0;                            // Deassert peripheral select 0
            PSEL1_ref = 0;                            // Deassert peripheral select 1
            PENABLE_ref = 0;                          // Deassert enable signal
            PREADY_ref = 0;                           // Clear ready signal
            
        endfunction

        // Setup phase function: Prepare transaction signals before data access
        function setup_phase;
            access_end_transition(); // Call function to handle access setup transition
            // Set up transaction signals based on the current sequence item
            PADDR_ref = seq_item.address;           // Set the target address
            PENABLE_ref = 0;                        // Ensure enable is deasserted during setup
            PPROT_ref = 3'b000;                     // Default protection level
            PWDATA_ref = seq_item.master_in;        // Capture write data
            PREADY_ref = 0;                         // Clear the ready signal
            // Choose the appropriate peripheral based on the address
            if (seq_item.address == 4000) begin
                PSEL1_ref = 0;
                PSEL0_ref = 1;
            end else if (seq_item.address == 4001) begin
                PSEL1_ref = 1;
                PSEL0_ref = 0;
            end else begin
                PSEL1_ref = 0;
                PSEL0_ref = 0;
            end
            // Define operation mode and strobe configuration based on process type
            if (seq_item.process == 7'b0000011) begin        // Read operation
                PWRITE_ref = 0;
                PSTRB_ref = 4'b0000;
            end else if (seq_item.process == 7'b0100011) begin // Write operation
                PWRITE_ref = 1;
                case (seq_item.data_size)
                    2'b00:                        // Byte access
                        PSTRB_ref = (4'b0001 << seq_item.address[1:0]);
                    2'b01:                        // Half-word access
                        PSTRB_ref = (4'b0011 << {seq_item.address[1],1'b0});
                    2'b10:                        // Word access
                        PSTRB_ref = 4'b1111;
                    default: PSTRB_ref = 4'b1111;
                endcase
            end
        endfunction

        // Access phase function: Activate transaction transfer signals
        function access_phase;
            PENABLE_ref = 1;                        // Assert the enable signal to initiate transfer
            PREADY_ref = (seq_item.valid && PENABLE_ref && seq_item.rst_n && (PSEL1_ref||PSEL0_ref)); // Generate ready signal based on transaction validity

            if (seq_item.valid && PENABLE_ref) begin
                PRDATA_ref = seq_item.slave_in;     // Capture data from slave during read operations
            end
        endfunction

        function access_end_transition;
            // Update outputs if an access has just finished
            if (end_access && PWRITE_ref) begin
                slave_out_ref = PWDATA_ref & {{8{PSTRB_ref[3]}},
                                              {8{PSTRB_ref[2]}},
                                              {8{PSTRB_ref[1]}},
                                              {8{PSTRB_ref[0]}}}; // Process write data update
            end

            if (end_access && !PWRITE_ref) begin
                master_out_ref = seq_item.PRDATA;   // Capture read data from sequence item
            end

            end_access = 0;                         // Reset end access signal
        endfunction

        // Report phase: Output final scoreboard results
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", "Scoreboard report phase completed", UVM_MEDIUM);
        endfunction // report_phase

    endclass // apb_scoreboare

endpackage // apb_scoreboard_pkg
