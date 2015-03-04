require 'spec_helper'

describe GamesController, type: :controller do

	before :each do 
		4.times do 
			FactoryGirl.create(:user)
		end
		@user = User.first
		@game = FactoryGirl.create(:game, user_ids: [1, 2, 3, 4])
		@player1 = @game.players.where(position: 0).first
		@player2 = @game.players.where(position: 1).first
		@player3 = @game.players.where(position: 2).first
		@player4 = @game.players.where(position: 3).first
		@first_turn  = FactoryGirl.create(:turn, past_turn_id: @game.turns.last.id, player_id: @player1.id)
		@user = @player1.user
		sign_in :user, @user
	end
	
	describe "GET # new" do

		it "assigns correct instance variables"  do
			get :new
			expect(assigns(:users)).to eq(User.all)
			expect(assigns(:game)).to be_a_new(Game)
		end

		it "renders the new template" do
			get :new
      expect(response).to render_template("new")
		end
	end

	describe "Get # show" do

		before :each do
			get :show, id: @game
		end

		describe "assigns correct instance variabes" do
			it "assigns @turn" do
				expect(assigns(:turn)).to be_a_new(Turn)
			end
		end
	end

	describe "POST # create" do

		pending "assigns correct @game instance variable" do
			post :create, game: { user_ids: ["1", "2", "3", "4"] }
			expect(assigns(:game)).to eq(@game)
		end

	end


end