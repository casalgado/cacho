class TurnsController < ApplicationController
  
  before_action :authenticate_user!
  
  def new
  end

  def create
    @turn = Turn.new(turn_params)
    @game = @turn.player.game
    if @turn.save
      if @turn.guess_type == "doubt"
        @turn.who_lost?.lose
      end
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
    params.require(:turn).permit(:player_id, :quantity, :face, :guess_type)
  end
end
