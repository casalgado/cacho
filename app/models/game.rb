class Game < ActiveRecord::Base

	# Virtual Attributes
	
	attr_accessor :user_ids

	# Callbacks

	after_create :load_players
	after_create :load_first_turn

	# Associations

	has_many :players
	has_many :users, through: :players
	has_many :hands, through: :players
	has_many :turns, through: :players

	# Methods


	# Loads players in games - used in gamescontroller#create

	def load_players
		self.user_ids.shuffle!.each do |user_id|
    	player = User.find(user_id).players.create(:position => self.user_ids.index(user_id), :game_id => self.id)
    	hand = player.hands.create # move a after create del player. 
   	end
 	end

 	# Loads first turn of game

 	def load_first_turn
 		self.players.last.turns.create(:round => 1)
 	end

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
		self.update(:flowing_right => !self.flowing_right, :round => self.round + 1)
	end

end
