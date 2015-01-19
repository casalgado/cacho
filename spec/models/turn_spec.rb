
require 'spec_helper'

describe Turn, :type => :model do

	before :each do
		@game = FactoryGirl.create(:game, user_ids: [1,2])
		@player1 = @game.players.first
		@player2 = @game.players.last
		@first_turn  = FactoryGirl.create(:turn, past_turn_id: @game.turns.last.id, player_id: @player1.id)
	end

	describe "who_lost? method" do

		before :each do
			@second_turn = FactoryGirl.create(:turn, past_turn_id: @first_turn.id, player_id: @player2.id, guess_type: 'doubt')
		end

		describe "doubter is correct" do

			before :each do 
				@player1.hands.last.update(dice: [2,2,2,2,2])
				@player2.hands.last.update(dice: [2,2,2,2,2])
			end

			it "number, other player must lose" do	
				expect(@second_turn.who_lost?).to eq(@player1)
			end

			it "aces, other player must lose" do
				@first_turn.update(face: 1, quantity: 3)
				expect(@second_turn.who_lost?).to eq(@player1)
			end

		end

		describe "doubter is wrong" do

			before :each do 
				@player1.hands.last.update(dice: [1,1,1,6,6])
				@player2.hands.last.update(dice: [2,2,2,2,2])
			end

			it "number, he must lose" do
				expect(@second_turn.who_lost?).to eq(@player2)
			end

			it "aces, he must lose" do
				@first_turn.update(face: 1, quantity: 3)
				expect(@second_turn.who_lost?).to eq(@player2)
			end

		end
	end

	describe "GuessValidator" do

		describe "aces to number" do

			it "bigger guess is valid" do
				@first_turn.update(face: 1, quantity: 3)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 2, quantity: 7)
				expect(second_turn).to be_valid
			end

			it "smaller guess is invalid" do
				@first_turn.update(face: 1, quantity: 3)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 2, quantity: 6)
				expect(second_turn).to_not be_valid
			end
		end

		describe "number to aces" do

			it "bigger guess is valid" do
				@first_turn.update(face: 5, quantity: 7)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 1, quantity: 4)
				expect(second_turn).to be_valid
			end

			it "smaller guess is invalid" do
				@first_turn.update(face: 5, quantity: 7)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 1, quantity: 3)
				expect(second_turn).to_not be_valid
			end

		end

		describe "number to number" do

			it "bigger quantity guess is valid" do
				@first_turn.update(face: 5, quantity: 5)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 6, quantity: 5)
				expect(second_turn).to be_valid
			end

			it "bigger face guess is valid" do
				@first_turn.update(face: 5, quantity: 5)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 5, quantity: 6)
				expect(second_turn).to be_valid
			end

			it "smaller guess is invalid" do
				@first_turn.update(face: 5, quantity: 5)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 5, quantity: 5)
				expect(second_turn).to_not be_valid
			end

		end

		describe "other guess types" do

			it "doubt is always valid" do
				@first_turn.update(face: 1, quantity: 3)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 1, quantity: 1, guess_type: 'doubt')
				expect(second_turn).to be_valid
			end
			
			# hay que cambiar este spec cuando se implemente tropical bien. 
			it "tropical is always valid" do
				@first_turn.update(face: 1, quantity: 3)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 1, quantity: 1, guess_type: 'tropical')
				expect(second_turn).to be_valid
			end

		end
	end
	

	
end