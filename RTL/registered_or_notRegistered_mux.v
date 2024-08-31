module reg_notReg #(
    parameter WIDTH = 18,
    parameter INREG = 1, // 1 for regestered and 0 for not regestered
    parameter RSTTYPE= 1 // 1 for syncronus and 0 for asyncronus
) (
    input CLK, RSTIN, CEIN,
    input [WIDTH-1:0] IN,
    output [WIDTH-1:0] OUT
);
reg [WIDTH - 1:0] OUT_REG;
generate
    if (RSTTYPE) begin
        always @(posedge CLK) begin // Active High Synchronous Reset
        if(RSTIN)
            OUT_REG <= 0;
        else if(CEIN)
            OUT_REG <= IN;
        end
    end   
    else begin
        always @(posedge CLK, posedge RSTIN) begin // Active High Asynchronous Reset
        if(RSTIN)
            OUT_REG <= 0;
        else if(CEIN)
            OUT_REG <= IN;
    end
    end  
endgenerate

assign OUT = (INREG)? OUT_REG : IN;
endmodule