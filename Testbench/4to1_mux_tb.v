module mux4to1_tb;

// Parameter
parameter WIDTH = 48;

// Inputs
reg [WIDTH-1:0] in0;
reg [WIDTH-1:0] in1;
reg [WIDTH-1:0] in2;
reg [WIDTH-1:0] in3;
reg [1:0] sel;

// Output
wire [WIDTH-1:0] out;

// Instantiate the MUX
mux4to1 #(WIDTH) dut (
    .in0(in0),
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .sel(sel),
    .out(out)
);

// Random stimulus for testbench
initial begin

    // Randomly assign values to inputs and selector
    repeat (10) begin
        #5 in0 = $random;  
           in1 = $random ;  
           in2 = $random ;  
           in3 = $random;  
           sel = $random ;           

        // Display the values and output
        #5 $display("Time: %0t | sel: %b | in0: %h | in1: %h | in2: %h | in3: %h | out: %h", 
                    $time, sel, in0, in1, in2, in3, out);
    end

    // End simulation
    #5 $stop;
end

endmodule
