// Michael Stroucken
// 98-154
// Tinytapeout Corral project

`default_nettype none

module game
  (input logic clock,
  input logic reset_n,
  input logic enter,
  input logic [2:0] move,
  output logic cowboypos,
  output logic horsepos,
  output logic gameover,
  output logic lostwon,
  output logic ready);
  
  typedef enum logic {IDLE, BUSY} state_t;
  state_t state = IDLE, nextState;

  logic [3:0] horsepos;
  logic [3:0] cowboypos;

  logic gameenter, gamegameover, gamelostwon, gameready;
  logic [2:0] gamemove;


  logic reset_n;
  assign reset_n =  !reset;

  // need random numbers 0 to 9,
  // 3 bits + 2 bits?
  lfsr #(5) lfsrinstance(.i_Clk(clock), .i_Enable(1'b0));

  logic [3:0] pVal[10] = { 4'd0, 4'd1, 4'd2, 4'd3, 4'd3, 4'd2, 4'd2, 4'd1, 4'd0, 4'd-1 };
  logic [3:0] qVal[10] = { 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0 };

endmodule: game
