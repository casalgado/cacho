class Game < ActiveRecord::Base

	# Associations

	has_many :players
	has_many :users, through: :players
	has_many :hands, through: :players
	has_many :turns, through: :players

	# Methods


	# Loads players in games - used in gamescontroller#create
	def load_players(array)
		array.shuffle!.each do |user_id|
    	player = User.find(user_id).players.create(:position => array.index(user_id), :game_id => self.id)
    	hand = player.hands.create
    	5.times do 
    		hand.dice << Die.new.roll
    	end
    	hand.save
   	end
 	end

  # (3) Used to determine dice in and off table
	def starting_dice # returns integer
		self.players.count * 5
	end

	def dice_on_table # returns array
  	self.hands.where(:round => Turn.find(self.last_turn_id).round).pluck(:dice).flatten!
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
		@players_remaining = self.players_remaining
		@players_remaining[(@players_remaining.index(Turn.find(self.last_turn_id).player) + var) % @players_remaining.size] if Turn.find(self.last_turn_id).player 
	end


	# Determines players still in game, searches for players without rank. 
	def remaining_players
		self.players.where(:rank => nil)
	end

	# Starts a new round after someone has guessed doubt - used in gamescontroller#show
	def new_round # Returns @player_who_lost to optimize controller 
		@player_who_lost = Turn.find(self.last_turn_id).who_lost?.lose
		self.remaining_players.each do |player|
			player.hands.last.new_hand
		end
		self.update(:flowing_right => !self.flowing_right, :round => self.round + 1)
		@player_who_lost
	end

end
