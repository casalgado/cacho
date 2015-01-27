class Player < ActiveRecord::Base

	# Callbacks

	before_validation :roll_hand

	# Associations

  belongs_to :user
  belongs_to :game
  has_many  :turns
  has_many  :hands

  # Validations

  validates :hands, presence:  true
  validates :user_id, presence: true

  # Methods


  # Tags hand for appropiate dice changes and sets rank if player is out of game.
  # Effects of this method are seen in the :roll_dice callback of the hand model. 
  def lose(dice)
		@hand = self.hands.last
		@hand.update(lose: @hand.lose + dice)
		self.set_rank if @hand.dice.size - dice <= 0
		self
	end


	# Sets rank for player in game, rank indicates player has lost.
	def set_rank
		self.update(:rank => self.game.players_remaining.count)
		# to be defined: how to rank player who has won game
	end

	private

	# creates and instance of hand after a player has been created. 
	def roll_hand
		if self.new_record? && self.hands.empty?
			self.hands.build
		end
	end

end
