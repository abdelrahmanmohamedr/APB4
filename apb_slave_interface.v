//////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed Ragab
/// Module-Name: slave_interface
//////////////////////////////////////////////////////////////////////////

module apb_slave_interface (PCLK, PRESETn, PADDR, PPROT, PSEL0, PSEL1, PENABLE, PWRITE, PWDATA, PSTRB, PREADY, PRDATA, write_data, read_data, valid);

    // Parameters
    parameter ADDR_WIDTH = 32;                              // Width of the address bus
    parameter DATA_WIDTH = 32;                              // Width of the data bus
    parameter STRB_WIDTH = DATA_WIDTH / 8;                  // Byte strobe width
    parameter IDLE_PHASE = 2'b00;                           // Idle state
    parameter SETUP_PHASE = 2'b01;                          // Setup state
    parameter ACCESS_PHASE = 2'b10;                         // Access state

    // Inputs
    input [DATA_WIDTH-1:0] read_data;                       // Data read from master
    input [DATA_WIDTH-1:0] PWDATA;                          // Write data from master
    input [ADDR_WIDTH-1:0] PADDR;                           // Address from master
    input [STRB_WIDTH-1:0] PSTRB;                           // Byte strobe from master
    input [2:0] PPROT;                                      // Protection bits from master
    input PCLK;                                             // Clock signal
    input PRESETn;                                          // Active low reset signal
    input PSEL1;                                            // Slave select signal for the first slave device
    input PSEL0;                                            // Slave select signal for the second slave device
    input PENABLE;                                          // Enable signal for the slave device
    input PWRITE;                                           // Write signal for the slave device
    input valid;                                            // Valid signal for the slave device

    // Outputs
    output reg [DATA_WIDTH-1:0] write_data;                 // Data to be written to the master device
    output reg [DATA_WIDTH-1:0] PRDATA;                     // Data to be written to the master device
    output PREADY;                                      // Ready signal to the master

    // Always block triggered on the rising edge of the clock
    always @(posedge PCLK) begin
        if (!PRESETn) begin
            write_data <= 0;                                // Reset write_data
            PRDATA <= 0;                                    // Reset PRDATA
        end else if (PREADY) begin
            if (PWRITE) begin
                write_data <= PWDATA & {{8{PSTRB[3]}},{8{PSTRB[2]}},{8{PSTRB[1]}},{8{PSTRB[0]}}};               // Write data to the master device
            end
        end
    end

    assign PREADY = (PENABLE && valid && PRESETn && (PSEL0||PSEL1)); // Generate ready signal based on select and enable signals

    always @(*) begin
        if (PREADY) begin
            PRDATA <= read_data;
        end
    end

endmodule


