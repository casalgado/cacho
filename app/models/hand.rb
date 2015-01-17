class Hand < ActiveRecord::Base
	
	serialize :dice, Array

	# Callbacks

	before_create :roll_dice

	# Associations

  belongs_to :player

  # Methods

	private

  def roll_dice
    previous_hand = self.player.hands.last
    if previous_hand
      self.round = previous_hand.round + 1
      previous_hand.dice.size.times do
        self.dice << Die.new.roll
      end
      self.dice.pop if previous_hand.lose
    else
      5.times do 
        self.dice << Die.new.roll
      end
  	end
  end

  
end

