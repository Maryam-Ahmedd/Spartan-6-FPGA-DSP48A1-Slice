module tb_DSP48A1;
    // Inputs
    reg [17:0] A, B, D;
    reg [47:0] C, PCIN;
    reg [17:0] BCIN;
    reg CARRYIN, CLK, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
    reg [7:0] OPMODE;

    // Outputs
    wire [35:0] M;
    wire [47:0] P, PCOUT;
    wire [17:0] BCOUT;
    wire CARRYOUT, CARRYOUTF;

    // Instantiate the DSP48A1 module
    DSP48A1 uut (
        .A(A), .B(B), .D(D), .C(C), .PCIN(PCIN), .BCIN(BCIN), .CARRYIN(CARRYIN), .CLK(CLK),
        .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),
        .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
        .OPMODE(OPMODE), .M(M), .P(P), .PCOUT(PCOUT), .BCOUT(BCOUT), .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF)
    );

    // Clock Generation
    initial CLK = 0;
    always #5 CLK = ~CLK;  // 10ns period

    // Testbench Logic
    initial begin
        // Initialize inputs
        A = 18'h0; B = 18'h0; D = 18'h0; C = 48'h0; PCIN = 48'h0; BCIN = 18'h0;
        CARRYIN = 0; CEA = 0; CEB = 0; CEC = 0; CECARRYIN = 0; CED = 0; CEM = 0; CEOPMODE = 0; CEP = 0;
        OPMODE = 8'h00;

        // Apply Reset
        RSTA = 1; RSTB = 1; RSTC = 1; RSTCARRYIN = 1; RSTD = 1; RSTM = 1; RSTOPMODE = 1; RSTP = 1;
        @(negedge CLK);
        RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0; RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0;

        // Test Case 1: Testing addition using pre-adder/substractor block then testing multiplication and check output M
        OPMODE = 8'b00010000;  // Addition mode
        A = 18'h2; B = 18'h3; D = 18'h1; 
        CEA = 1; CEB = 1; CED =1; CEM = 1; CEOPMODE = 1; CECARRYIN = 1; CEP = 1; CEC=1;
       repeat (4) @(negedge CLK);
        if (M == 36'h8) $display("Test Case 1 Passed");
        else $display("Test Case 1 Failed");

        // Test Case 2: Testing Subtraction using pre-adder/substractor block then testing multiplication and check output M
        OPMODE = 8'b01010000;  // Subtraction mode
        A = 18'h2; B = 18'h3; D = 18'h5;
        repeat (4) @(negedge CLK);
        if (M == 36'h4) $display("Test Case 2 Passed");
        else $display("Test Case 2 Failed");
        
        // Test Case 3: Testing addition with carryin using post-adder/substractor block then checking output P and CARRYOUT
        OPMODE = 8'b00111101;  
        A = 18'h2; B = 18'h3; D = 18'h2; C=48'h1;
       repeat (4) @(negedge CLK);
        if (P == 48'hc && CARRYOUT==0 ) $display("Test Case 3 Passed");
        else $display("Test Case 3 Failed");

        // Test Case 4: Testing substraction with carryin using post-adder/substractor block then checking output P and CARRYOUT
        OPMODE = 8'b10111101;  
        A = 18'h2; B = 18'h3; D = 18'h2; C=48'hf;
       repeat (4) @(negedge CLK);
        if (P == 48'h4 && CARRYOUT==0 ) $display("Test Case 4 Passed");
        else $display("Test Case 4 Failed");

        // Test Case 5: checking concatination
        OPMODE = 8'b00100011;  
        A = 18'hfffff; B = 18'hfffff; D = 18'hfffff; C=48'hf;
       repeat (4) @(negedge CLK);
        if (P == 48'h0 && CARRYOUT==1 ) $display("Test Case 5 Passed");
        else $display("Test Case 5 Failed");

        $stop;
    end
endmodule
