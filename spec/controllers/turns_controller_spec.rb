require 'spec_helper'

describe TurnsController, type: :controller do

	before :each do
		4.times do 
			FactoryGirl.create(:user)
		end
		@game = FactoryGirl.create(:game, user_ids: [1, 2, 3, 4])
		@player1 = @game.players.where(position: 0).first
		@player2 = @game.players.where(position: 1).first
		@player3 = @game.players.where(position: 2).first
		@player4 = @game.players.where(position: 3).first
		@first_turn  = FactoryGirl.create(:turn, past_turn_id: @game.turns.last.id, player_id: @player1.id)
		@user = @player2.user
		sign_in :user, @user
	end
	
	describe "POST # create" do

		it "assigns correct @game instance variable"  do
			post :create, turn: { past_turn_id: @game.turns.last.id, player_id: @player2.id, quantity: 6, face: 6 }
			expect(assigns(:game)).to eq(@game)
		end

		it "assigns correct @game instance variable"  do
			expect { post :create, turn: { past_turn_id: @game.turns.last.id, player_id: @player2.id, quantity: 6, face: 6 }}.to change(Turn, :count).by(1)
		end

		it "assigns correct @game instance variable"  do
			post :create, turn: { past_turn_id: @game.turns.last.id, player_id: @player2.id, quantity: 6, face: 6, guess_type: "#{@player2.id}" }
			expect(assigns[:turn].tropical_id).to eq("#{@player2.id}")
		end


	end

end