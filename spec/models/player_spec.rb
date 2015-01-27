
require 'spec_helper'

describe Player, :type => :model do

	before :each do
		@game = FactoryGirl.create(:game, user_ids: [1,2,3,4])
		@player = @game.players.first
	end
	

	it "created players belong to game" do
		@game.players.each do |player|
			expect(player.game_id).to eq(@game.id)
		end
	end

	it "created players create a hand" do
		expect(@player.hands.last).to be_an_instance_of(Hand)
	end

	describe "lose method" do

		it "test if lose is set to hand" do
			@player.lose(1)
			expect(@player.hands.last.lose).to eq(1)
		end

		it "test if set_rank is set when hand is one die" do
			@player.hands.last.update(dice: [1])
			@player.lose(1)
			expect(@player.rank).to be_truthy
		end
	end

	describe "lose_two_dice method" do

		it "Loses player two dice when called" do
			@player.lose(2)
			expect(@player.hands.last.dice.size).to eq(5)
			expect(@player.hands.last.lose).to eq(2)
		end

	end

	describe "win_one_die method" do

		it "Wins player one die when called - HAS 5 DICE" do
			@player.hands.last.update(dice: [1,2,3,4,5])
			@player.lose(-1)
			expect(@player.hands.last.dice.size).to eq(5)
			expect(@player.hands.last.lose).to eq(-1)
		end

		it "Wins player one die when called - HAS <5 DICE" do
			@player.hands.last.update(dice: [1,2,3,4])
			@player.lose(-1)
			expect(@player.hands.last.dice.size).to eq(4)
			expect(@player.hands.last.lose).to eq(-1)
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