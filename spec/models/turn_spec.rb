
require 'spec_helper'

describe Turn, :type => :model do

	before :each do
		@game = FactoryGirl.create(:game, user_ids: [1,2,3,4])
		@player1 = @game.players.where(position: 0).first
		@player2 = @game.players.where(position: 1).first
		@player3 = @game.players.where(position: 2).first
		@player4 = @game.players.where(position: 3).first
		@first_turn  = FactoryGirl.create(:turn, past_turn_id: @game.turns.last.id, player_id: @player1.id)
	end

	describe "who_lost? method with doubt" do

		before :each do
			@second_turn = FactoryGirl.create(:turn_doubt, past_turn_id: @first_turn.id, player_id: @player2.id)
		end

		describe "Doubter is correct" do

			before :each do 
				@player1.hands.last.update(dice: [2,2,2,2,2])
				@player2.hands.last.update(dice: [2,2,2,2,2])
				@player3.hands.last.update(dice: [2,2,2,2,2])
				@player4.hands.last.update(dice: [2,2,2,2,2])
			end

			it "ON number, other player must lose" do	
				expect(@second_turn.who_lost?).to eq(@player1)
			end

			it "ON aces, other player must lose" do
				@first_turn.update(face: 1, quantity: 3)
				expect(@second_turn.who_lost?).to eq(@player1)
			end
		end

		describe "Doubter is wrong" do

			before :each do 
				@player1.hands.last.update(dice: [1,1,1,6,6])
				@player2.hands.last.update(dice: [2,2,2,2,2])
			end

			it "ON number, he must lose" do
				expect(@second_turn.who_lost?).to eq(@player2)
			end

			it "ON aces, he must lose" do
				@first_turn.update(face: 1, quantity: 3)
				expect(@second_turn.who_lost?).to eq(@player2)
			end

		end
	end

	describe "who_lost? method with single tropical" do

		before :each do
			@second_turn = FactoryGirl.create(:turn_tropical, past_turn_id: @first_turn.id , player_id: @player2.id)
			@third_turn  = FactoryGirl.create(:turn_doubt, past_turn_id: @second_turn.id, player_id: @player3.id)
		end

		describe "Doubter is correct" do

			before :each do 
				@player1.hands.last.update(dice: [2,2,2,2,2])
				@player2.hands.last.update(dice: [2,2,2,2,2])
				@player3.hands.last.update(dice: [2,2,2,2,2])
			end

			it "ON tropical other player must lose" do	
				@third_turn.update_attribute(:tropical_id, "#{@player2.id}")
				expect(@third_turn.who_lost?).to eq(@player2)
			end

			it "ON guess other player must lose" do	
				expect(@third_turn.who_lost?).to eq(@player1)
			end
		end

		describe "Doubter is wrong" do

			before :each do 
				@player1.hands.last.update(dice: [6,6,6,6,6])
				@player2.hands.last.update(dice: [1,2,3,4,5])
				@player3.hands.last.update(dice: [2,2,2,2,2])
			end

			it "ON tropcial he must lose" do
				@third_turn.update_attribute(:tropical_id, "#{@player2.id}")
				expect(@third_turn.who_lost?).to eq(@player3)
			end

			it "ON guess he must lose" do	
				expect(@third_turn.who_lost?).to eq(@player3)
			end

		end
	end

	describe "who_lost? method with double tropical" do

		before :each do
			@second_turn = FactoryGirl.create(:turn_tropical, past_turn_id: @first_turn.id , player_id: @player2.id)
			@third_turn  = FactoryGirl.create(:turn_tropical, past_turn_id: @second_turn.id, player_id: @player3.id)
			@fourth_turn = FactoryGirl.create(:turn_doubt, past_turn_id: @third_turn.id , player_id: @player4.id)
		end

		describe "Doubter is correct" do

			before :each do 
				@player1.hands.last.update(dice: [2,2,2,2,2])
				@player2.hands.last.update(dice: [2,2,2,2,2])
				@player3.hands.last.update(dice: [2,2,2,2,2])
				@player4.hands.last.update(dice: [2,2,2,2,2])
			end

			it "ON first tropical other player must lose" do
				@fourth_turn.update_attribute(:tropical_id, "#{@player2.id}")	
				expect(@fourth_turn.who_lost?).to eq(@player2)
			end

			it "ON second tropical other player must lose" do	
				@fourth_turn.update_attribute(:tropical_id, "#{@player3.id}")	
				expect(@fourth_turn.who_lost?).to eq(@player3)
			end

			it "ON guess other player must lose" do	
				expect(@fourth_turn.who_lost?).to eq(@player1)
			end

		end

		describe "doubter is wrong" do

			before :each do 
				@player1.hands.last.update(dice: [6,6,6,6,6])
				@player2.hands.last.update(dice: [1,2,3,4,5])
				@player3.hands.last.update(dice: [1,2,3,4,5])
				@player4.hands.last.update(dice: [2,2,2,2,2])
			end

			it "ON first tropical he must lose" do
				@fourth_turn.update_attribute(:tropical_id, "#{@player2.id}")	
				expect(@fourth_turn.who_lost?).to eq(@player4)
			end

			it "ON second tropical he must lose" do	
				@fourth_turn.update_attribute(:tropical_id, "#{@player3.id}")	
				expect(@fourth_turn.who_lost?).to eq(@player4)
			end

			it "ON guess he must lose" do	
				expect(@fourth_turn.who_lost?).to eq(@player4)
			end

		end
	end

	describe "GuessValidator works " do

		describe "ON aces to number" do

			it "Bigger guess is valid" do
				@first_turn.update(face: 1, quantity: 3)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 2, quantity: 7)
				expect(second_turn).to be_valid
			end

			it "Smaller guess is invalid" do
				@first_turn.update(face: 1, quantity: 3)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 2, quantity: 6)
				expect(second_turn).to_not be_valid
			end
		end

		describe "ON number to aces" do

			it "Bigger guess is valid" do
				@first_turn.update(face: 5, quantity: 7)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 1, quantity: 4)
				expect(second_turn).to be_valid
			end

			it "Smaller guess is invalid" do
				@first_turn.update(face: 5, quantity: 7)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 1, quantity: 3)
				expect(second_turn).to_not be_valid
			end

		end

		describe "ON number to number" do

			it "Bigger quantity guess is valid" do
				@first_turn.update(face: 5, quantity: 5)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 6, quantity: 5)
				expect(second_turn).to be_valid
			end

			it "Bigger face guess is valid" do
				@first_turn.update(face: 5, quantity: 5)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 5, quantity: 6)
				expect(second_turn).to be_valid
			end

			it "Smaller guess is invalid" do
				@first_turn.update(face: 5, quantity: 5)
				second_turn = FactoryGirl.build(:turn, past_turn_id: @first_turn.id, face: 5, quantity: 5)
				expect(second_turn).to_not be_valid
			end

		end

		describe "ON other guess types" do

			it "Doubt is always valid" do
				second_turn = FactoryGirl.build(:turn_doubt   , past_turn_id: @first_turn.id, player_id: @player2.id, face: 1, quantity: 1)
				expect(second_turn).to be_valid
			end
			
			it "Tropical is always valid the first time in the round" do
				second_turn = FactoryGirl.build(:turn_tropical, past_turn_id: @first_turn.id, player_id: @player2.id, face: 1, quantity: 1)
				expect(second_turn).to be_valid
			end

			it "Tropical not valid the second time in the round" do
				second_turn = FactoryGirl.create(:turn_tropical, past_turn_id: @first_turn.id, player_id: @player2.id, face: 1, quantity: 1)
				third_turn  = FactoryGirl.build(:turn_tropical, past_turn_id: second_turn.id, player_id: @player2.id, face: 1, quantity: 1)
				expect(third_turn).to_not be_valid
			end

			describe "Stake" do

				before :each do 
					@player1.hands.last.update(dice: [1,1])
					@player2.hands.last.update(dice: [1,1])
					@player3.hands.last.update(dice: [3,3,3,3,3])
					@player4.hands.last.update(dice: [2,2])
				end

				it "is valid when more than half of dice are left" do
					second_turn = FactoryGirl.build(:turn_stake, past_turn_id: @first_turn.id, player_id: @player2.id, face: 1, quantity: 1)
					expect(second_turn).to be_valid
				end

				it "is invalid when less than half of dice are left" do
					@player4.hands.last.update(dice: [2])
					second_turn = FactoryGirl.build(:turn_stake, past_turn_id: @first_turn.id, player_id: @player2.id, face: 1, quantity: 1)
					expect(second_turn).to_not be_valid
				end

			end


		end
	end
	
	describe "showdown? method is " do

		it "true ON last turn doubt" do
			@second_turn = FactoryGirl.create(:turn_doubt, past_turn_id: @first_turn.id, player_id: @player2.id)
			expect(@second_turn.reload.showdown?).to be true
		end

		it "true ON last turn stake" do
			@second_turn = FactoryGirl.create(:turn_stake, past_turn_id: @first_turn.id, player_id: @player2.id)
			expect(@second_turn.reload.showdown?).to be true
		end

		it "false ON different round" do
			@second_turn = FactoryGirl.create(:turn_doubt, past_turn_id: @first_turn.id, player_id: @player2.id)
			@game.new_round
			expect(@second_turn.reload.showdown?).to be false
		end
	end

	describe "won_stake? method" do

		before :each do 
			@player1.hands.last.update(dice: [1,1])
			@player2.hands.last.update(dice: [1,1])
			@player3.hands.last.update(dice: [3,3,3,3,3])
			@player4.hands.last.update(dice: [2,2])
		end

		it "loses player two dice when wrong (by more dice ACES)" do
			second_turn = FactoryGirl.create(:turn, past_turn_id: @first_turn.id, player_id: @player2.id, face: 1, quantity: 5)
			third_turn  = FactoryGirl.create(:turn_stake, past_turn_id: second_turn.id, player_id: @player3.id)
			third_turn.won_stake?
			expect(third_turn.won_stake?).to be false
		end

		it "loses player two dice when wrong (by less dice ACES)" do
			second_turn = FactoryGirl.create(:turn, past_turn_id: @first_turn.id, player_id: @player2.id, face: 1, quantity: 3)
			third_turn  = FactoryGirl.create(:turn_stake, past_turn_id: second_turn.id, player_id: @player3.id)
			third_turn.won_stake?
			expect(third_turn.won_stake?).to be false
		end

		it "loses player two dice when wrong (by more dice NUMBER)" do
			second_turn = FactoryGirl.create(:turn, past_turn_id: @first_turn.id, player_id: @player2.id, face: 3, quantity: 10)
			third_turn  = FactoryGirl.create(:turn_stake, past_turn_id: second_turn.id, player_id: @player3.id)
			third_turn.won_stake?
			expect(third_turn.won_stake?).to be false
		end

		it "loses player two dice when wrong (by less dice NUMBER)" do
			second_turn = FactoryGirl.create(:turn, past_turn_id: @first_turn.id, player_id: @player2.id, face: 3, quantity: 8)
			third_turn  = FactoryGirl.create(:turn_stake, past_turn_id: second_turn.id, player_id: @player3.id)
			third_turn.won_stake?
			expect(third_turn.won_stake?).to be false
		end


		it "wins player one dice when correct ACES" do
			second_turn = FactoryGirl.create(:turn, past_turn_id: @first_turn.id, player_id: @player2.id, face: 1, quantity: 4)
			third_turn  = FactoryGirl.create(:turn_stake, past_turn_id: second_turn.id, player_id: @player3.id)
			third_turn.won_stake?
			expect(third_turn.won_stake?).to be true
		end

		it "wins player one dice when correct NUMBER" do
			second_turn = FactoryGirl.create(:turn, past_turn_id: @first_turn.id, player_id: @player2.id, face: 3, quantity: 9)
			third_turn  = FactoryGirl.create(:turn_stake, past_turn_id: second_turn.id, player_id: @player3.id)
			third_turn.won_stake?
			expect(third_turn.won_stake?).to be true
		end

	end

	
end