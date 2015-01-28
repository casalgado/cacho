class TurnsController < ApplicationController
  
  before_action :authenticate_user!

  def new
  end

  def create
    @turn = Turn.new(turn_params)

    if @turn.guess_type.to_i != 0
      @turn.tropical_id = @turn.guess_type
      @turn.guess_type  = 'doubt'
    end

    @game = @turn.player.game

    if @turn.save # pasar a un after create. 

    else
      flash[:alert] = @turn.errors.messages[:base][0]
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
    params.require(:turn).permit(:player_id, :quantity, :face, :guess_type, :tropical_id)
  end
end
