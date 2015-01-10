class TurnsController < ApplicationController
  def new
  end

  def create
    @turn = Turn.new(turn_params)
    @game = @turn.player.game
    @turn.update(:round => @game.round, :past_turn_id => @game.last_turn_id)
    if @turn.valid_guess?
      @turn.save
      @game.update(:last_turn_id => @turn.id)
      @game.save # hay que mover esta accion a games update?
    else
      flash[:alert] = "no puedes decir eso"
    end
    redirect_to game_path(@game)
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def delete
  end

  private

  def turn_params
    params.require(:turn).permit(:player_id, :quantity, :face, :guess_type)
  end
end
