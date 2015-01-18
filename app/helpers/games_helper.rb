module GamesHelper

	def authenticate_player
		@game = Game.find(params[:id])
		if current_user.in_game?(@game)
      @current_player = @game.players.where(:user_id => current_user.id).first
    else
      flash[:alert] = "You are not in game"
      redirect_to new_game_path
    end
	end

end
