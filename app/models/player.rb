class Player < ActiveRecord::Base

	# Associations

  belongs_to :user
  belongs_to :game
  has_many :turns
  has_many :hands

  # Methods


  # Tags losing hand and sets rank if player has lost
  def lose
		@hand = self.hands.last
		@hand.update(:lose => true)
		self.set_rank if @hand.dice.size == 1
		self
	end

	# Sets rank for player in game, rank indicates player has lost
	def set_rank
		self.update(:rank => self.game.players_remaining)
		# to be defined: how to rank player who has won game
	end

end
