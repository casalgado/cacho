
require 'spec_helper'

describe Hand, type: :model do

	before :each do
		@game = FactoryGirl.create(:game, user_ids: [1,2,3,4])
		@player = @game.players.first
		@hand = @player.hands.last
	end
	

	it "created hand belongs to the correct player" do
		expect(@hand.player).to eq(@player)
	end

	it "created hand has five dice" do
		expect(@hand.dice.size).to eq(5)
	end

	it "the defualt round is 1" do
		expect(@hand.round).to eq(1)
	end

	describe "new_round" do # revisar estos tests, deben ser del method roll_dice, no rew_round
													# new_round es un method de game. 

		it "if hand set to lose(1) is reduced by one die" do
			@player.lose(1)
			@game.new_round
			expect(@player.reload.hands.last.dice.size).to eq(4)
		end

		it "if hand set to lose(2) is reduced by two die" do
			@player.lose(2)
			@game.new_round
			expect(@player.reload.hands.last.dice.size).to eq(3)
		end

		it "if hand set to lose(-1) and size is 4 or less it is increased by one die" do
			@player.hands.last.update(dice: [1,2,3,4])
			@player.lose(-1)
			@game.new_round
			expect(@player.reload.hands.last.dice.size).to eq(5)
		end

		it "if hand set to lose(-1) and size is 5 not increased dice and hand.lose = -1" do
			@player.lose(-1)
			@game.new_round
			expect(@player.reload.hands.last.dice.size).to eq(5)
			expect(@player.reload.hands.last.lose).to eq(-1)
		end

		it "if hand set to lose(1) and size is 5 with hand.lose at -1, result should be 5 dice and hand.lose = 0" do
			@player.hands.last.update(lose: -1)
			@player.lose(1)
			@game.new_round
			expect(@player.reload.hands.last.dice.size).to eq(5)
			expect(@player.reload.hands.last.lose).to eq(0)
		end

		it "if hand not set to lose remains with five dice" do
			@game.new_round
			expect(@player.reload.hands.last.dice.size).to eq(5)
		end

		it "updates round attribute" do
			@game.new_round
			expect(@player.reload.hands.last.round).to eq(2)
		end

	end



	it "set_rank method" do
		@player.set_rank
		expect(@player.rank).to eq(4)
		player2 = @game.players.last
		player2.set_rank
		expect(player2.rank).to eq(3) 
	end



	



	
end