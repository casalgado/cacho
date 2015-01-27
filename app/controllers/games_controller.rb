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
    @last_turn = @game.turns.last
    @player_who_lost = @game.round_loser if @last_turn.guess_type == "doubt"
    @player_who_staked =  @last_turn.player if @last_turn.guess_type == "stake"
    @game.new_round if params[:new_round] && @game.round == @last_turn.round # esta mal
    @turn = Turn.new
    @dice_remaining = @game.starting_dice - @game.dice_off_table
    @player_in_turn = @player_who_staked || @player_who_lost || @game.next_player     
  end

  def edit
  end

  def update
  end

  def delete
  end


end
