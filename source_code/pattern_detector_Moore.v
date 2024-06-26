module pattern_detector_Moore (
    input clk,
    input restn,
    input in,
    output out
);

// Binary Encoding
parameter IDLE = 3'b000,
          S1 = 3'b001, 
          S11 = 3'b010, 
          S110 = 3'b011, 
          S1101 = 3'b100,
          S11010 = 3'b101, 
          S110101 = 3'b110;

reg [2:0] current_state, next_state;

// In the Moore FSM, output only depends on current state
assign out = current_state == S110101 ? 1 : 0;

// update current state
always @(posedge clk) begin // synchronous reset
    if (!restn)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// update next state
always @(current_state or in) begin
    case (current_state)
        IDLE : begin
            if (in)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1 : begin
            if (in)
                next_state = S11;
            else
                next_state = IDLE;
        end
        S11 : begin
            if (!in)
                next_state = S110;
            else
                next_state = S11;
        end
        S110 : begin
            if (in)
                next_state = S1101;
            else
                next_state = IDLE;
        end
        S1101 : begin
            if (!in)
                next_state = S11010;
            else
                next_state = IDLE;
        end
        S11010 : begin
            if (in)
                next_state = S110101;
            else
                next_state = IDLE;
        end
        S110101 : begin
            if (in)
                next_state = S1;
            else
                next_state = IDLE;
        end
    endcase
end
    
endmodule