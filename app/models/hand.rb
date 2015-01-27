
class Hand < ActiveRecord::Base
	
	serialize :dice, Array

	# Callbacks

	before_create :roll_dice

	# Associations

  belongs_to :player

  # Methods

  def tropical?
    self.dice.uniq.size == 5
  end

  def adjust_dice_quantity
    self.dice.size - self.lose
  end

	private

  def roll_dice
    previous_hand = self.player.hands.last
    if previous_hand
      self.round = previous_hand.round + 1
      previous_hand.adjust_dice_quantity.times do
        self.dice << Die.new.roll
      end
      if self.dice.size == 6
        self.dice.pop
        self.lose = -1
      end
    else
      5.times do 
        self.dice << Die.new.roll
      end
  	end
  end

  
end

