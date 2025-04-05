//////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed Ragab
/// Module-Name: apb_master_interface
//////////////////////////////////////////////////////////////////////////

module apb_master_interface (PCLK, PRESETn, PADDR, PPROT, PSEL0, PSEL1, PENABLE, PWRITE, PWDATA, PSTRB, PREADY, PRDATA, address, write_data, read_data, process, data_size);

    // Parameters
    parameter ADDR_WIDTH = 32;                              // Width of the address bus
    parameter DATA_WIDTH = 32;                              // Width of the data bus
    parameter STRB_WIDTH = DATA_WIDTH / 8;                  // Byte strobe width
    parameter IDLE_PHASE = 2'b00;                           // Idle state
    parameter SETUP_PHASE = 2'b01;                          // Setup state
    parameter ACCESS_PHASE = 2'b10;                         // Access state
    
    // Inputs
    input [DATA_WIDTH-1:0] PRDATA;                          // Data read from slave
    input [DATA_WIDTH-1:0] write_data;                      // Data to be written to slave
    input [ADDR_WIDTH-1:0] address;                         // Address for the transaction
    input [6:0] process;                                    // Process control signal
    input [1:0] data_size;                                  // Data size signal
    input PCLK;                                             // Clock signal
    input PRESETn;                                          // Reset (active low)
    input PREADY;                                           // Ready signal from slave
    
    // Outputs
    output reg [ADDR_WIDTH-1:0] PADDR;                      // APB address output
    output reg [DATA_WIDTH-1:0] PWDATA;                     // Write data output for APB
    output reg [DATA_WIDTH-1:0] read_data;                  // Read data captured from APB
    output reg [STRB_WIDTH-1:0] PSTRB;                      // Byte strobe output
    output reg [2:0] PPROT;                                 // Protection bits output
    output reg PSEL1;                                       // Peripheral select 1
    output reg PSEL0;                                       // Peripheral select 0
    output reg PENABLE;                                     // APB enable signal
    output reg PWRITE;                                      // APB write signal
    
    // Internal signals
    reg [1:0] current_state;                                // Current state of FSM
    reg [1:0] next_state;                                   // Next state of FSM

    // Always block triggered on the rising edge of the clock
    always @(posedge PCLK) begin
        if (!PRESETn) begin
            current_state <= IDLE_PHASE;                    // Reset state to IDLE
        end else begin
            current_state <= next_state;                    // Update state
        end
    end

    // Always block triggered on the rising edge of the clock
    always @(*) begin
            case (current_state)
                IDLE_PHASE: begin
                    PSEL0 <= 0;                             // Deassert peripheral select 0
                    PSEL1 <= 0;                             // Deassert peripheral select 1
                    PENABLE <= 0;                           // Deassert enable signal
                end

                SETUP_PHASE: begin
                    PADDR <= address;                       // Set address
                    PENABLE <= 0;                           // Deassert enable signal
                    PPROT <= 3'b000;                        // Set protection level to 0
                    PWDATA <= write_data;               // Set write data
                    if (address == 4000) begin              // Select peripheral based on address
                        PSEL1 <= 0;
                        PSEL0 <= 1;
                    end else if (address == 4001) begin
                        PSEL1 <= 1;
                        PSEL0 <= 0;
                    end else begin
                        PSEL1 <= 0;
                        PSEL0 <= 0;
                    end
                    if (process == 7'b0000011) begin        // Read operation
                        PWRITE <= 0;                        // Set write signal to 0
                        PSTRB <= 4'b0000;                   // Set strobe to 0
                    end else if (process == 7'b0100011) begin // Write operation
                        PWRITE <= 1;                        // Set write signal to 1
                        case (data_size)
                            2'b00:                          // Byte
                                PSTRB <= (4'b0001 << address[1:0]);
                            2'b01:                          // Half-word
                                PSTRB <= (4'b0011 << {address[1],1'b0});
                            2'b10:                          // Word
                                PSTRB <= 4'b1111;
                            default: PSTRB <= 4'b1111;
                        endcase
                    end
                end
                
                ACCESS_PHASE: begin
                    PENABLE <= 1;                           // Enable the transfer
                end
                
                default: begin
                    PADDR <= 0;                             // Reset address
                    PWDATA <= 0;                            // Reset write data
                    PSTRB <= 0;                             // Reset strobe
                    PPROT <= 0;                             // Reset protection bits
                    PSEL1 <= 0;                             // Reset peripheral select 1
                    PSEL0 <= 0;                             // Reset peripheral select 0
                    PENABLE <= 0;                           // Reset enable signal
                    PWRITE <= 0;                            // Reset write signal
                end
            endcase
        end

    // Always block for next state logic
    always @(*) begin
        case (current_state)
            IDLE_PHASE: begin
                if (process == (7'b0000011) || process == (7'b0100011)) begin
                    next_state <= SETUP_PHASE;              // Transition to SETUP
                end else begin
                    next_state <= IDLE_PHASE;               // Remain in IDLE
                end
            end

            SETUP_PHASE: begin
                if (!PSEL0 && !PSEL1) begin
                    next_state <= IDLE_PHASE;                 // Transition to ACCESS
                end else begin
                    next_state <= ACCESS_PHASE;                 // Transition to ACCESS
                end
            end 

            ACCESS_PHASE: begin
                if (PREADY && ((process == (7'b0000011)) || (process == (7'b0100011)))) begin
                    next_state <= SETUP_PHASE;              // Transition to SETUP
                end else if (PREADY) begin
                    next_state <= IDLE_PHASE;               // Transition to IDLE
                end else begin
                    next_state <= ACCESS_PHASE;             // Remain in ACCESS
                end
            end
            default: next_state <= IDLE_PHASE;              // Default to IDLE
        endcase
    end

    // Always block to capture read data on the rising edge of the clock
    always @(posedge PCLK) begin
        if (!PRESETn) begin
            read_data <= 0;
        end else if (PREADY && !PWRITE) begin
            read_data <= PRDATA;                // Capture read data
        end
    end

endmodule





