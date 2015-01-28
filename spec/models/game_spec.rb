
require 'spec_helper'

describe Game, :type => :model do

	before :each do
		@game = FactoryGirl.create(:game, user_ids: [1,2,3,4])
		@player1 = @game.players.where(position: 0).first
		@player2 = @game.players.where(position: 1).first
		@player3 = @game.players.where(position: 2).first
		@player4 = @game.players.where(position: 3).first
	end
	
	it "has a valid factory" do
		expect(@game).to be_valid
	end

	describe "player position methods" do

		it "creates players with correct users" do
			expect(@game.players.pluck(:user_id)).to include(1)
			expect(@game.players.pluck(:user_id)).to include(2)
			expect(@game.players.pluck(:user_id)).to include(3)
			expect(@game.players.pluck(:user_id)).to include(4)
		end

		it "creates players with correct positions" do
			expect(@game.players.pluck(:position).uniq.size).to eq(4)
			expect(@game.players.pluck(:position).sort).to eq([0,1,2,3])
		end

		it "players_remaining method" do
			loser = @game.players.first
			loser.update(rank: 4)
			expect(@game.players_remaining.size).to eq(3)
			expect(@game.players_remaining.pluck(:id)).to_not include(loser.id)
		end
	end

	describe "player_in_turn method" do

		it "ON returns correct player after doubt" do
			@player3.hands.last.update(lose: 1)	
			@game.new_round
			expect(@game.player_in_turn).to eq(@player3)
		end

		it "ON returns correct player after stake and lose" do
			@player3.hands.last.update(lose: 2)	
			@game.new_round
			expect(@game.player_in_turn).to eq(@player3)
		end

		it "ON returns correct player after stake and win" do
			@player3.hands.last.update(lose: -1)	
			@game.new_round
			expect(@game.player_in_turn).to eq(@player3)
		end
	end

	describe "next_player method"

		it "ON the start of game" do
			expect(@game.next_player).to eq(@player1)
		end

	describe "dice counting methods" do

		it "starting_dice method" do
			expect(@game.starting_dice).to eq(20)
		end

		it "dice_on_table method" do
			expect(@game.dice_on_table).to be_an_instance_of(Array)
		end

		it "dice_off_table method" do
			expect(@game.dice_off_table).to be_an_instance_of(Fixnum)
		end
	end

	describe "new_round method" do

		it "updates proper game attributes" do
			@game.new_round
			expect(@game.flowing_right).to eq(false)
			expect(@game.round).to eq(2)
			@game.new_round
			expect(@game.flowing_right).to eq(true)
			expect(@game.round).to eq(3)
		end

		it "creates new hands for players" do
			hands = @game.players.first.hands.size
			@game.new_round
			expect(@game.reload.players.first.hands.size).to eq(hands + 1)
		end
	end

	describe "loser_of_round method" do

		it "ON player lost 1 dice" do
			@player4.hands.last.update(lose: 1)
			expect(@game.loser_of_round(1)).to eq(@player4)
		end		

		it "ON player lost 2 dice" do
			@player4.hands.last.update(lose: 2)
			expect(@game.loser_of_round(1)).to eq(@player4)
		end		

		it "ON player lost -1 dice" do
			@player4.hands.last.update(lose: -1)
			expect(@game.loser_of_round(1)).to eq(@player4)
		end

		it "ON returns nil when no loser" do
			@player4.hands.last.update(lose: 1)
			@game.new_round
			expect(@game.loser_of_round(2)).to be(nil)
		end
	end
	
end