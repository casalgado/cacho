class GamesController < ApplicationController
  
  # Create callback after create para load_players

  def new
    @user  = current_user
    @users = User.all
    @game  = Game.new
  end

  def create
    @game = Game.new(user_ids: params[:users])
    @game.save
    redirect_to game_path(@game)
  end

  def index
  end

  def show
    @user = current_user
    @game = Game.find(params[:id])
    @last_turn = @game.turns.last
    @player_who_lost = @last_turn.who_lost? if @last_turn && @last_turn.guess_type == "doubt"
    @game.new_round if params[:new_round] && @game.round == @last_turn.round
    @turn = Turn.new
    @dice_remaining = @game.starting_dice - @game.dice_off_table
    @player_in_turn = @player_who_lost || @game.next_player 

    # Determines if user is allowed in game. 
    # Pasar esto a un games_helper.
    if current_user.in_game?(@game)
      @current_player = @game.players.where(:user_id => @user.id).first
    else
      flash[:alert] = "You are not in game"
      redirect_to new_game_path
    end
  end

  def edit
  end

  def update
  end

  def delete
  end


end
