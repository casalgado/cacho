class GamesController < ApplicationController

  # Helpers

  include GamesHelper
  
  # Filters

  # Determines if user is allowed in game.
  before_action :authenticate_user!
  before_action :authenticate_player, only: [:show] 

  def new
    @users = User.all
    @game  = Game.new
  end

  def create
    @game = Game.new(user_ids: params[:user_ids])
    @game.save
    redirect_to game_path(@game)
  end

  def index
  end

  def show
    @game = Game.find(params[:id])
    @turn = Turn.new
  end

  def edit
  end

  def update
    @game = Game.find(params[:id])
    @game.new_round if @game.round == @game.turns.last.round
    redirect_to game_path(@game)
  end

  def delete
  end


end
