class Hand < ActiveRecord::Base
	
	serialize :dice, Array

	# Associations

  belongs_to :player

  # Methods

  def new_hand
		@new_hand = self.player.hands.create(:round => self.round + 1)
		self.dice.size.times do
			@new_hand.dice << Die.new.roll
		end
		@new_hand.dice.pop if self.lose
		@new_hand.save
	end
  
end
