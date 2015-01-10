class Turn < ActiveRecord::Base

	# Associations

  belongs_to :player

  # Methods

  # To determine if a is valid - used in turnscontroller#create
  def valid_guess?
  	@last_turn = Turn.find(self.past_turn_id)
  	if @last_turn.quantity
  	 	if self.guess_type == "doubt" || self.guess_type == "tropical"
  	 		true
  	 	else
	  		
	  		if (@last_turn.face == 1) && (self.face != 1)
					if self.quantity.to_i >= (@last_turn.quantity.to_i * 2) + 1
						true
					else
						false
					end
				elsif (@last_turn.face != 1) && (self.face == 1)
					if self.quantity.to_i >= (@last_turn.quantity.to_i / 2) + 1
						true
					else
						false
					end
				else
					if (self.quantity > @last_turn.quantity) || (self.quantity == @last_turn.quantity && self.face > @last_turn.face)
						true
					else
						false
					end
				end
			end
  	else
  		true
  	end
  end

  # Determines which player lost dice - used in gamescontroller#show
  def who_lost?
		@past_turn = Turn.find(self.past_turn_id)
		if @past_turn.face != 1
			if @past_turn.quantity.to_i <= self.player.game.dice_on_table.count(@past_turn.face) + self.player.game.dice_on_table.count(1)
				self.player
			else
				@past_turn.player
			end
		else
			if @past_turn.quantity.to_i <= self.player.game.dice_on_table.count(@past_turn.face)
				self.player
			else
				@past_turn.player
			end
		end
	end

end
