module reg_notReg_tb;

// Parameters
parameter WIDTH = 18;
parameter INREG = 1;  // Registered mux
parameter RSTTYPE = 1; // Synchronous reset

// Inputs
reg CLK;
reg RSTIN;
reg CEIN;
reg [WIDTH-1:0] IN;

// Outputs
wire [WIDTH-1:0] OUT;

// Instantiate the DUT 
reg_notReg #(.WIDTH(WIDTH), .INREG(INREG), .RSTTYPE(RSTTYPE)) dut (
    .CLK(CLK),
    .RSTIN(RSTIN),
    .CEIN(CEIN),
    .IN(IN),
    .OUT(OUT)
);

// Clock generation
always #5 CLK = ~CLK;  

// Initial stimulus
initial begin
    // Initialize signals
    CLK = 0;
    RSTIN = 0;
    CEIN = 0;
    IN = 0;

    // Apply synchronous reset and observe the behavior
    @(negedge CLK);
    RSTIN = 1;  // Assert synchronous reset
    @(negedge CLK);
    IN = 18'h3FFFF;
    @(negedge CLK);
    if (OUT == 0)
        $display("PASS: Synchronous reset is working correctly");
    else
        $display("FAIL: Synchronous reset did not reset the output to 0");

    @(negedge CLK);
    RSTIN = 0;  // Deassert synchronous reset
    IN = 0;

    // Enable clock and provide data
    @(negedge CLK);
    CEIN = 1;
    IN = 18'h3FFFF;  
    @(negedge CLK);
    if (OUT == IN)
        $display("PASS: Data is correctly passed to the output");
    else
        $display("FAIL: Data was not passed to the output correctly");

    // Change input value and check the updated output
    @(negedge CLK);
    IN = 18'h00001;  
    @(negedge CLK);
    if (OUT == IN)
        $display("PASS: Data is correctly updated in the output");
    else
        $display("FAIL: Data was not updated correctly");

    // Disable clock enable and check if output holds
    @(negedge CLK);
    CEIN = 0;
    IN = 18'hAAAAA;  // the value of the output shouldnot change by changing the value of input
    @(negedge CLK);
    if (OUT != IN)
        $display("PASS: Clock enable is working correctly");
    else
        $display("FAIL: Clock enable failed");

    // Enable clock again and check if output updates
    @(negedge CLK);
    CEIN = 1;
    @(negedge CLK);
    if (OUT == IN)
        $display("PASS: Data change when clock enable was set");
    else
        $display("FAIL: Data did not change when clock enable was set");

    // End simulation
    $stop;
end

endmodule
