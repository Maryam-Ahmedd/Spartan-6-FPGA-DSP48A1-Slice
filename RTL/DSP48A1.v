module DSP48A1 #(
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,
    parameter CREG = 1,
    parameter DREG = 1,
    parameter MREG = 1,
    parameter PREG = 1,
    parameter CARRYINREG = 1,
    parameter CARRYOUTREG = 1,
    parameter OPMODEREG = 1,
    parameter CARRYINSEL = 1, // 1 for OPMODE[5], 0 for CARRYIN
    parameter B_INPUT = 1, // 1 for DIRECT, 0 for CASCADE
    parameter RSTTYPE = 1 // 1 for SYNC, 0 for ASYNC
) (
    input [17:0] A, B, D,
    input [47:0] C, PCIN,
    input [17:0] BCIN,
    input CARRYIN, CLK, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP,
    input RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP,
    input [7:0] OPMODE,
    output [35:0] M,
    output [47:0] P, PCOUT,
    output [17:0] BCOUT,
    output CARRYOUT, CARRYOUTF
);
    wire [7:0] OPMODE_OUT;
    wire [17:0] B_OUT, A0_OUT, A1_OUT, B0_OUT, B1_OUT, D_OUT, PRE_ADDER_SUB_OUT, B1REG_IN;
    wire [35:0] MULTIPLICATION, M_OUT;
    wire [47:0] C_OUT, X_Mux_OUT, Z_Mux_OUT, POST_ADDER_SUB_OUT;
    wire CARRYIN_CASCADE_OUT, CARRYIN_OUT, CARRY;

    // First stage
    assign B_OUT = (B_INPUT) ? B : BCIN;
    reg_notReg #( .WIDTH(8), .INREG(OPMODEREG), .RSTTYPE(RSTTYPE)) OPMODE_RER_NOTREG (.CLK(CLK), .RSTIN(RSTOPMODE), .CEIN(CEOPMODE), .IN(OPMODE), .OUT(OPMODE_OUT));


    // Second stage
    reg_notReg #( .WIDTH(18), .INREG(DREG), .RSTTYPE(RSTTYPE)) D_RER_NOTREG (.CLK(CLK), .RSTIN(RSTD), .CEIN(CED), .IN(D), .OUT(D_OUT));
    reg_notReg #( .WIDTH(18), .INREG(B0REG), .RSTTYPE(RSTTYPE)) B0_RER_NOTREG (.CLK(CLK), .RSTIN(RSTB), .CEIN(CEB), .IN(B_OUT), .OUT(B0_OUT));
    reg_notReg #( .WIDTH(18), .INREG(A0REG), .RSTTYPE(RSTTYPE)) A0_RER_NOTREG (.CLK(CLK), .RSTIN(RSTA), .CEIN(CEA), .IN(A), .OUT(A0_OUT));
    reg_notReg #( .WIDTH(48), .INREG(CREG), .RSTTYPE(RSTTYPE)) C_RER_NOTREG (.CLK(CLK), .RSTIN(RSTC), .CEIN(CEC), .IN(C), .OUT(C_OUT));
    
    // Third stage
    assign PRE_ADDER_SUB_OUT = (OPMODE_OUT[6]) ? (D_OUT - B0_OUT) : (D_OUT + B0_OUT);
    assign B1REG_IN = (OPMODE_OUT[4]) ? PRE_ADDER_SUB_OUT : B0_OUT;
    reg_notReg #( .WIDTH(18), .INREG(B1REG), .RSTTYPE(RSTTYPE)) B1_RER_NOTREG (.CLK(CLK), .RSTIN(RSTB), .CEIN(CEB), .IN(B1REG_IN), .OUT(B1_OUT));
    reg_notReg #( .WIDTH(18), .INREG(A1REG), .RSTTYPE(RSTTYPE)) A1_RER_NOTREG (.CLK(CLK), .RSTIN(RSTA), .CEIN(CEA), .IN(A0_OUT), .OUT(A1_OUT));
    assign BCOUT = B1_OUT;

    // fourth stage
    assign MULTIPLICATION = B1_OUT * A1_OUT;
    reg_notReg #( .WIDTH(36), .INREG(MREG), .RSTTYPE(RSTTYPE)) M_RER_NOTREG (.CLK(CLK), .RSTIN(RSTM), .CEIN(CEM), .IN(MULTIPLICATION), .OUT(M_OUT));
    reg_notReg #( .WIDTH(36), .INREG(1), .RSTTYPE(RSTTYPE)) M_BUFFER (.CLK(CLK), .RSTIN(0), .CEIN(1), .IN(M_OUT), .OUT(M));

    assign CARRYIN_CASCADE_OUT = (CARRYINSEL) ? OPMODE_OUT[5] : CARRYIN;
    reg_notReg #( .WIDTH(1), .INREG(CARRYINREG), .RSTTYPE(RSTTYPE)) CARRYIN_RER_NOTREG (.CLK(CLK), .RSTIN(RSTCARRYIN), .CEIN(CECARRYIN), .IN(CARRYIN_CASCADE_OUT), .OUT(CARRYIN_OUT));

    // fifth stage
    mux4to1 #(.WIDTH(48)) X_Mux (.in0 (48'h0), .in1({{12{1'b0}}, M_OUT}), .in2(P), .in3({D_OUT[11:0], A1_OUT[17:0], B1_OUT[17:0]}), .sel(OPMODE_OUT[1:0]), .out(X_Mux_OUT));
    mux4to1 #(.WIDTH(48)) Z_Mux (.in0 (48'h0), .in1(PCIN), .in2(P), .in3(C_OUT), .sel(OPMODE_OUT[3:2]), .out(Z_Mux_OUT));

    assign {CARRY, POST_ADDER_SUB_OUT} = (OPMODE_OUT[7]) ? (Z_Mux_OUT - (X_Mux_OUT + CARRYIN_OUT)) : (Z_Mux_OUT + X_Mux_OUT + CARRYIN_OUT);
    reg_notReg #( .WIDTH(1), .INREG(CARRYOUTREG), .RSTTYPE(RSTTYPE)) CARRYOUT_RER_NOTREG (.CLK(CLK), .RSTIN(RSTCARRYIN), .CEIN(CECARRYIN), .IN(CARRY), .OUT(CARRYOUT));
    assign CARRYOUTF = CARRYOUT;

    reg_notReg #( .WIDTH(48), .INREG(PREG), .RSTTYPE(RSTTYPE)) P_RER_NOTREG (.CLK(CLK), .RSTIN(RSTP), .CEIN(CEP), .IN(POST_ADDER_SUB_OUT), .OUT(P));
    assign PCOUT = P;
endmodule
