class Turn < ActiveRecord::Base

	# Callbacks

	before_validation :load_attributes
	# Agregar un callback para clear los quantitys-faces si es tropical o doubt

	# Validations

	validates_with GuessValidator

	# Associations

  belongs_to :player

  # Methods  

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

	private

	def load_attributes
		if self.round.nil?
			game = self.player.game
    	self.round = game.round 
    	self.past_turn_id = game.turns.last.id if game.turns.last
    end
  end

end
