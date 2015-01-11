class GamesController < ApplicationController
  
  def new
    @user  = current_user
    @users = User.all
    @game  = Game.new
  end

  def create
    @game = Game.new
    @game.save
    @game.load_players(params[:users])
    redirect_to game_path(@game)
  end

  def index
  end

  def show
    @user = current_user
    @game = Game.find(params[:id])
    @last_turn = Turn.find(@game.last_turn_id)
    if @last_turn.guess_type == "doubt"
      @player_who_lost = Turn.find(@game.last_turn_id).who_lost?
    end
    if params[:new_round]
      @game.new_round
    end
    @turn = Turn.new
    @player_in_turn = @player_who_lost || @game.next_player || @game.players.first

    # Determines if user is allowed in game.
    if @user.in_game?(@game)
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
