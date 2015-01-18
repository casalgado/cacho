require 'spec_helper'

describe GamesController, type: :controller do

	before :each do 
		4.times do 
			FactoryGirl.create(:user)
		end
		@user = User.first
		@game = FactoryGirl.create(:game, user_ids: [1, 2, 3, 4])
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

			it "assigns @last_turn" do
				expect(assigns(:last_turn)).to eq(@game.turns.last)
			end

			it "assigns @turn" do
				expect(assigns(:turn)).to be_a_new(Turn)
			end

		end

	end

end