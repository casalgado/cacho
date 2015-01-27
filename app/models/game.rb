class Game < ActiveRecord::Base

	# Virtual Attributes
	
	attr_accessor :user_ids

	# Callbacks

	before_validation :load_players
 	after_create :load_first_turn

	# Associations

	has_many :players
	has_many :users, through: :players
	has_many :hands, through: :players
	has_many :turns, through: :players

	# Validations

 	validates :round, numericality: true
	validates :players, presence:  true

	# Methods

  # (3) Used to determine dice in and off table
	def starting_dice # returns integer
		self.players.count * 5
	end

	def dice_on_table # returns array
  	self.hands.where(:round => self.turns.last.round).pluck(:dice).flatten!
	end

	def dice_off_table # returns integer
		self.starting_dice - self.dice_on_table.size
	end

	# Determines players that have not lost
	def players_remaining
		self.players.where(:rank => nil)
	end

	# Determines next player in game based on last turn - used in gamescontroller#show
	def next_player
		var = -1
		var = 1 if flowing_right
		players_remaining = self.players_remaining
		last_turn = self.turns.last
		players_remaining[(players_remaining.index(last_turn.player) + var) % players_remaining.size]
	end

	# Determines players still in game, searches for players without rank. 
	def remaining_players
		self.players.where(:rank => nil)
	end

	# Starts a new round after someone has guessed doubt - used in gamescontroller#show
	def new_round 
		self.remaining_players.each do |player|
			player.hands.create
		end
		self.update_attributes(:flowing_right => !self.flowing_right, :round => self.round + 1)
	end

	# Returns turns in round where guess was tropical
	def tropical_turns
		self.turns.where(guess_type: 'tropical', round: self.round)
	end

	# Determines if it is the first turn of the round. 
  def first_turn?
  	turns_in_round = self.turns.where(round: self.round).count
  	turns_in_round -= 1 if self.round == 1
  	turns_in_round == 0
  end

  # Determines user of last round
  def round_loser # Returns player
  	if losing_hand = self.hands.where(lose: true, round: self.round).first
  		losing_hand.player
  	end
  end

	private

	# Loads players in games - used in gamescontroller#create
	def load_players
		if self.new_record? && self.players.empty?
			self.user_ids.shuffle!.each_with_index do |user_id, index|
				self.players.build(position: index, user_id: user_id)
	   	end
	  end
 	end

 	# Loads first turn of game
 	def load_first_turn
 		self.players.last.turns.build(round: 1)
 	end

end
