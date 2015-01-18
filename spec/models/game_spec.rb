
require 'spec_helper'

describe Game, :type => :model do

	before :each do
		@game = FactoryGirl.create(:game, user_ids: [1,2,3,4])
	end
	
	it "has a valid factory" do
		expect(@game).to be_valid
	end

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

	it "starting_dice method" do
		expect(@game.starting_dice).to eq(20)
	end

	it "dice_on_table method" do
		expect(@game.dice_on_table).to be_an_instance_of(Array)
	end

	it "dice_off_table method" do
		expect(@game.dice_off_table).to be_an_instance_of(Fixnum)
	end

	it "players_remaining method" do
		loser = @game.players.first
		loser.update(rank: 4)
		expect(@game.players_remaining.size).to eq(3)
		expect(@game.players_remaining.pluck(:id)).to_not include(loser.id)
	end

	it "next_player method" do
		expect(@game.next_player).to eq(@game.players.first)
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
	
end