class Turn < ActiveRecord::Base


	# Virtual Attributes
	
	attr_accessor :tropical_id

	# Callbacks

	before_validation :load_attributes
	after_create :set_appropiate_guess_values

	# Validations

	validates_with GuessValidator

	# Associations

  belongs_to :player


  # Methods  

  # (2) Determines game and past_turn of turn
  def game
  	self.player.game
  end

  def past_turn
  	Turn.find(self.past_turn_id)
  end

  # Determines if turn is showdown - Showdown: When dice are revealed and a new round is set to begin. 
  def showdown?
  	self.game.round == self.game.turns.last.round && (self.guess_type == "doubt" || self.guess_type == "stake") 
  end

  # Determines which player lost dice - used in gamescontroller#show
  def who_lost?
		@past_turn = self.past_turn
		@last_normal_guess_player = self.game.turns.where(guess_type: 'normal').last.player
		if @past_turn.guess_type == 'tropical' && self.tropical_id
			if Player.find(self.tropical_id.to_i).hands.last.tropical?
				self.player
			else
				Player.find(self.tropical_id.to_i)
			end
		else
			if @past_turn.face != 1
				if @past_turn.quantity.to_i <= self.player.game.dice_on_table.count(@past_turn.face) + self.player.game.dice_on_table.count(1)
					self.player
				else
					@last_normal_guess_player
				end
			else
				if @past_turn.quantity.to_i <= self.player.game.dice_on_table.count(@past_turn.face)
					self.player
				else
					@last_normal_guess_player
				end
			end
		end
	end

	def test
		self.game
	end

	# Determines the outcome of a stake
	def won_stake?
		@past_turn = self.past_turn
		if @past_turn.face != 1
			if @past_turn.quantity.to_i == self.player.game.dice_on_table.count(@past_turn.face) + self.player.game.dice_on_table.count(1)
				true
			else
				false
			end
		else
			if @past_turn.quantity.to_i == self.player.game.dice_on_table.count(@past_turn.face)
				true
			else
				false
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
    if self.guess_type.to_i != 0
    	self.tropical_id = self.guess_type
    	self.guess_type = 'doubt'
    end
  end

  def set_appropiate_guess_values
  	if self.guess_type == 'doubt'
  		self.update_attribute(:face, nil) 
  		self.update_attribute(:quantity, nil) 
  	elsif self.guess_type == 'tropical'
  		self.update_attribute(:face, self.past_turn.face) 
  		self.update_attribute(:quantity, self.past_turn.quantity) 
  	end
  end

end
