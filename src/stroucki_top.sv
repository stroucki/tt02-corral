// Michael Stroucken
// 98-154
// Tinytapeout Corral project

`default_nettype none

module stroucki_top;
  (input logic clock,
  input logic reset,
  input logic [2:0] move,
  input logic enter,
  output logic [3:0] data,
  output logic gameover,
  output logic lostwon,
  output logic ready);

  typedef enum logic [2:0] {COWBOY, HORSE, GAME, IDLE} state_t;
  state_t state = IDLE, nextState;

  // want sequential:
  // data, gameover, lostwon, ready, state

  logic [3:0] horsepos;
  logic [3:0] cowboypos;

  logic gameenter, gamegameover, gamelostwon, gameready;
  logic [2:0] gamemove;
  

  logic reset_n;
  assign reset_n =  !reset;

  game gameinstance(.clock(clock), .reset_n(reset_n),
    .cowboypos(cowboypos), .horsepos(horsepos), .gameover(gamegameover),
    .lostwon(gamelostwon), .ready(gameready), .enter(gameenter),
    .move(gamemove));

  // current state logic
  always_comb begin
    gameenter = 0;
    gamemove = 3'b0;
    data = 4'b0;

    unique case (state)
      IDLE: if (enter)
        begin
          gameenter = 1;
          gamemove = move;
        end
      COWBOY:
      HORSE:
      GAME:
      
    endcase
  end

  // next state logic
  always_comb
    unique case (state)
      IDLE: nextState = IDLE;
      COWBOY: nextState = HORSE;
      HORSE: nextState = GAME;
      GAME: nextState = COWBOY;
    endcase

  always @(posedge clock, negedge reset_n) begin
    if (~reset_n) begin
      state <= IDLE;
      data <= 4'b0;
      gameover <= 1;
      lastwon <= 0;
      ready <= 0;
    end
    else begin
      if (enter && state == IDLE) begin
        state <= HORSE;
      end
      else if (state == GAME) begin
        ready <= 1;
        lostwon <= gamelostwon;
        gameover <= gamegameover;
        if (gameready) begin
          state <= IDLE;
        end
      end
      else if (state == COWBOY) begin
        data <= cowboypos;
        state <= nextState;
      else if (state == HORSE) begin
        data <= horsepos;
        state <= nextState;
      end
    end
  end

endmodule: stroucki_top
