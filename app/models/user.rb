class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players
  has_many :games, through: :players

  # Methods


  # Determines if a user is in a given game
  def in_game?(game)
		if game.players.pluck(:user_id).include?(self.id)
			true
		else
			false
		end
	end
end
