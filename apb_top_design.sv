//////////////////////////////////////////////////////////////////////////
/// Name: Abdelrahman Mohamed Ragab
/// Module-Name: apb_top_design
//////////////////////////////////////////////////////////////////////////

module apb_top_design (apb_int apbint);

    // Instantiate the master interface
    apb_master_interface master_DUT (
        .PADDR(apbint.PADDR), 
        .PWDATA(apbint.PWDATA), 
        .PSTRB(apbint.PSTRB), 
        .PPROT(apbint.PPROT), 
        .PSEL1(apbint.PSEL1), 
        .PSEL0(apbint.PSEL0), 
        .PENABLE(apbint.PENABLE), 
        .PWRITE(apbint.PWRITE), 
        .PREADY(apbint.PREADY), 
        .PRDATA(apbint.PRDATA), 
        .PCLK(apbint.clk), 
        .PRESETn(apbint.rst_n), 
        .address(apbint.address), 
        .process(apbint.process), 
        .data_size(apbint.data_size), 
        .read_data(apbint.master_out), 
        .write_data(apbint.master_in)
    );

    // Instantiate the slave interface
    apb_slave_interface slave_DUT (
        .PADDR(apbint.PADDR), 
        .PWDATA(apbint.PWDATA), 
        .PSTRB(apbint.PSTRB), 
        .PPROT(apbint.PPROT), 
        .PSEL1(apbint.PSEL1), 
        .PSEL0(apbint.PSEL0), 
        .PENABLE(apbint.PENABLE), 
        .PWRITE(apbint.PWRITE), 
        .PREADY(apbint.PREADY), 
        .PRDATA(apbint.PRDATA), 
        .PCLK(apbint.clk), 
        .PRESETn(apbint.rst_n), 
        .read_data(apbint.slave_in), 
        .write_data(apbint.slave_out), 
        .valid(apbint.valid)
    );
    
endmodule