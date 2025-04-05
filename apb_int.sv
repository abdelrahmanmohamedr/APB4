////////////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed
/// Module-Name: apb_int
////////////////////////////////////////////////////////////////////////////////

interface apb_int (clk);

    // Parameters
    parameter ADDR_WIDTH = 32;                              // Width of the address bus
    parameter DATA_WIDTH = 32;                              // Width of the data bus
    parameter STRB_WIDTH = DATA_WIDTH / 8;                  // Byte strobe width
    
    // Input signals
    input bit clk;                                          // Clock signal

    // Internal signals
    logic [DATA_WIDTH-1:0] master_in;                       // Data read from slave
    logic [DATA_WIDTH-1:0] slave_in;                        // Data to be written to slave
    logic [ADDR_WIDTH-1:0] address;                         // Address for the transaction
    logic [ADDR_WIDTH-1:0] master_out;                      // APB address output
    logic [DATA_WIDTH-1:0] slave_out;                       // Write data output for APB
    logic [DATA_WIDTH-1:0] PRDATA;                          // Data read from slave
    logic [ADDR_WIDTH-1:0] PADDR;                           // Address for the transaction
    logic [DATA_WIDTH-1:0] PWDATA;                          // Write data for slave
    logic [STRB_WIDTH-1:0] PSTRB;                           // Byte strobe signals
    logic [6:0] process;                                    // Process control signal
    logic [2:0] PPROT;                                      // Protection bits
    logic [1:0] data_size;                                  // Data size signal
    logic rst_n;                                            // Reset (active low)
    logic valid;                                            // Valid signal
    logic PSEL1;                                            // Peripheral select 1
    logic PSEL0;                                            // Peripheral select 0
    logic PENABLE;                                          // Enable signal
    logic PWRITE;                                           // Write signal
    logic PREADY;                                           // Ready signal from slave

endinterface // apb_int