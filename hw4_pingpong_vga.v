`timescale 1ns / 1ps
`timescale 1ns / 1ps
module top(
    input  clk,
    input  rst,
    input  sw_r,
    input  sw_l,
    output [7:0] led_r,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b,
    output hsync,
    output vsync
);

    wire led_clk;
    wire vga_clk;

    wire click_r, click_l;
    wire [2:0] state, state1, state2;
    wire [3:0] score_r, score_l;
	
    button R1(.in(sw_r), .clk(clk), .rst(rst), .click(click_r));
    button L1(.in(sw_l), .clk(clk), .rst(rst), .click(click_l));
	
    divclk U1(
        .clk(clk),
        .rst(rst),
        .led_clk(led_clk),
        .vga_clk(vga_clk)
    );
	
    FSM_state U2(
        .clk(clk), .rst(rst),
        .sw_r(click_r), .sw_l(click_l),
        .led_r(led_r),
        .score_r(score_r), .score_l(score_l),
        .state(state), .state1(state1), .state2(state2)
    );
	
    led_ctr U3(
        .clk(led_clk), .rst(rst),
        .state(state),
        .score_r(score_r), .score_l(score_l),
        .state2(state2),
        .led_r(led_r)
    );
	
    score_ctr U4(
        .clk(clk), .rst(rst),
        .state(state), .state1(state1),
        .score_r(score_r), .score_l(score_l)
    );

    VGA U5(
        .clk(vga_clk),
        .rst(rst),
        .led_r(led_r),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b),
        .hsync(hsync),
        .vsync(vsync)
    );

endmodule


module button(
	output click,
	input in,clk,rst
);

	parameter bound = 20'd1000000;

	reg [19:0] decnt;
	reg sig_dly,sig;
	
	always@(posedge clk or posedge rst)begin
		if(rst)begin
			decnt <= 20'd0;
			sig <= 1'd0;
		end
		else begin
			if(in == 1'b1)begin
				if(decnt < bound)begin
					decnt <= decnt + 20'd1;
					sig <= 1'b0;
				end
				else begin
					decnt <= decnt;
					sig <= 1'b1;
				end
			end
			else begin
				decnt <= 20'd0;
				sig <= 1'd0;
			end
		end
	end
	
	always@(posedge clk or posedge rst)begin
		if(rst)begin
			sig_dly <= 1'b0;
		end
		else begin
			sig_dly <= sig;
		end
	end
	
	assign click = sig & ~sig_dly;
	
endmodule

module divclk (
	input clk, rst,
	output led_clk,
	output vga_clk
);
	reg [27:0] cnt;
	
	assign led_clk = cnt[24];
	assign vga_clk = cnt[1];
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			cnt <= 0;
		end
		else begin
			cnt <= cnt + 1;
		end
	end
endmodule 

module FSM_state(
    input clk, rst,
    input sw_r, sw_l,
    input [7:0] led_r,     
	input [3:0] score_r,
	input [3:0] score_l,
	input [3:0] state2,
	output reg [2:0]  state1,
    output reg [2:0]  state
);
    parameter init = 3'd5,
			  ball_r = 3'd0,  
              ball_l = 3'd1,  
			  win_r = 3'd2,  
              win_l = 3'd3,  
              play = 3'd4;  
	 
	reg win;
	
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= init;
			state1 <= init;
			win <= 0;
        end 
		else begin
			state1 <= state;
            case (state)
				init : begin
					if (sw_r) begin
						state <= ball_r;
					end
					else if (sw_l) begin
						state <= ball_l;
					end
				end
                ball_r: begin
					if (led_r == 8'b1000_0000 && sw_l == 1) begin
						state <= ball_l;
					end
					else if ((led_r == 8'b0000_0000 && !sw_l)|| sw_l == 1) begin
						state <= win_r;
					end
                end
                ball_l: begin
                    if (led_r == 8'b0000_0001 && sw_r == 1) begin
						state <= ball_r;
					end
					else if ((led_r == 8'b0000_0000 && !sw_r)|| sw_r == 1) begin
						state <= win_l;
					end
                end
                win_r: begin
					state <= play;
					win <= 1;
                end
                win_l: begin
					state <= play;
					win <= 0;
                end
                play: begin
					case (win)
						1 : begin
							if (sw_r) begin
								state <= ball_r;   
							end
						end
						0 : begin
							if (sw_l) begin
								state <= ball_l;   
							end
						end
					endcase
                end
            endcase
        end
    end
endmodule

module score_ctr(
    input clk, rst,
    input [2:0] state,
	input [2:0] state1,
    output reg [3:0] score_r, score_l
);
	parameter init = 3'd5,
			  ball_r = 3'd0,  
              ball_l = 3'd1,  
			  win_r = 3'd2,  
              win_l = 3'd3,  
              play = 3'd4;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			score_r <= 0;
			score_l <= 0;
		end 
		else begin
			case(state)
				win_r: begin
					if (state1 == ball_r) begin
						score_r <= score_r + 1; 
					end
				end
				win_l: begin
					if (state1 == ball_l) begin
						score_l <= score_l + 1; 
					end 
				end
				default: begin
					score_r <= score_r;
					score_l <= score_l;
				end
			endcase
		end
	end
endmodule

module led_ctr(
    input clk, rst,
    input [2:0] state,
	input [3:0] score_r, score_l,
	output reg [2:0] state2,
    output reg [7:0] led_r
);
    parameter init = 3'd5,
			  ball_r = 3'd0,  
              ball_l = 3'd1,  
			  win_r = 3'd2,  
              win_l = 3'd3,  
              play = 3'd4; 
			  
	
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led_r <= 8'b0000_0001;
        end 
		else begin
			state2 <= state;
            case (state)
				init: begin
					led_r <= 8'b0000_0001;
				end
                ball_r: begin
					if (state2 == play) begin
						led_r <= 8'b0000_0001;
					end
					else begin
						led_r <= led_r << 1;
					end
                end
                ball_l: begin 
					if (state2 == play) begin
						led_r <= 8'b1000_0000;
					end
					else begin
						led_r <= led_r >> 1;
					end
                end
                win_r: begin
                    led_r <= {score_l, score_r};
                end
                win_l: begin
                    led_r <= {score_l, score_r};
                end
                play: begin
					led_r <= {score_l, score_r};
                end
				default : begin
					led_r <= led_r;
				end
            endcase
        end
    end
endmodule

module VGA(
    input  wire       clk,    
    input  wire       rst,
    input  wire [7:0] led_r,     
    output reg  [3:0] vga_r,
    output reg  [3:0] vga_g,
    output reg  [3:0] vga_b,
    output wire       hsync,
    output wire       vsync
);

    localparam integer H_SYNC_CYCLES   = 96;
    localparam integer H_BACK_PORCH    = 48;
    localparam integer H_ACTIVE_VIDEO  = 640;
    localparam integer H_FRONT_PORCH   = 16;
    localparam integer H_TOTAL         = 800;

    localparam integer V_SYNC_CYCLES   = 2;
    localparam integer V_BACK_PORCH    = 33;
    localparam integer V_ACTIVE_VIDEO  = 480;
    localparam integer V_FRONT_PORCH   = 10;
    localparam integer V_TOTAL         = 525;

    localparam integer H_VISIBLE_START = H_SYNC_CYCLES + H_BACK_PORCH; 
    localparam integer V_VISIBLE_START = V_SYNC_CYCLES + V_BACK_PORCH; 

    reg [9:0] h_count;
    reg [9:0] v_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count <= 10'd0;
            v_count <= 10'd0;
        end else begin
            if (h_count == H_TOTAL-1) begin
                h_count <= 10'd0;
                if (v_count == V_TOTAL-1) v_count <= 10'd0;
                else                      v_count <= v_count + 10'd1;
            end else begin
                h_count <= h_count + 10'd1;
            end
        end
    end

    assign hsync = (h_count < H_SYNC_CYCLES) ? 1'b0 : 1'b1;
    assign vsync = (v_count < V_SYNC_CYCLES) ? 1'b0 : 1'b1;

    wire signed [11:0] x = $signed({1'b0,h_count}) - H_VISIBLE_START;
    wire signed [11:0] y = $signed({1'b0,v_count}) - V_VISIBLE_START;

    wire video_on = (x >= 0 && x < H_ACTIVE_VIDEO && y >= 0 && y < V_ACTIVE_VIDEO);

    integer i;
    integer cx, dx, dy;
    integer dist2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            vga_r <= 4'h0;
            vga_g <= 4'h0;
            vga_b <= 4'h0;
        end 
		else begin
            vga_r <= 4'h0;
            vga_g <= 4'h0;
            vga_b <= 4'h0;

            if (video_on) begin
                for (i = 0; i < 8; i = i + 1) begin
                    cx = 120 + i*60;
                    dx = x - cx;
                    dy = y - 240;
                    dist2 = dx*dx + dy*dy;

                    if (dist2 <= 30*30) begin
                        if (led_r[7 - i]) begin
                            vga_r <= 4'h0; vga_g <= 4'hF; vga_b <= 4'h0;
                        end else begin
                            vga_r <= 4'h0; vga_g <= 4'h0; vga_b <= 4'h0;
                        end
                    end
                end
            end
        end
    end

endmodule
