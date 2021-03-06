require 'rails_helper'
module Api::V1
  RSpec.describe GameSessionsController, type: :controller do
    def user_login()
      # User Creation
      @controller = RegistrationsController.new
      @user_attr = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
      post :sign_up_email,params: { user: @user_attr },format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      @user_json = json
    end

    def check_aggregates(user)
      user.acad_entity_scores.each do |aggregate_score|
        puts aggregate_score.acad_entity.to_json
        check_aggregate(aggregate_score)
      end
    end

    def check_aggregate(acad_entity_score)
      score_list =   acad_entity_score.user.acad_scores(acad_entity_score.acad_entity )
      average =  (score_list.reduce(0) { |sum, obj| sum + obj.value.to_f })/(score_list.size)
      expect(acad_entity_score.average).to be_within(0.1).of(average)
      maximum = score_list.max {|a,b| a.value.to_f <=> b.value.to_f }
      expect(acad_entity_score.maximum).to be_within(0.1).of(maximum.value)
      expect(acad_entity_score.last.to_f).to be_within(0.1).of(score_list.last.value.to_f)
      puts average
      puts maximum.value
    end

    def create_game_session_call auth, game_holder_id
      @game_session_attr = FactoryGirl.attributes_for(:game_session).except(:user_id)
      @game_session_attr[:session_score] = (FactoryGirl.attributes_for(:session_score))
      @game_session_attr[:game_holder_id] = game_holder_id
      request.headers["Authorization"] = auth
      post :create,params: { game_session: @game_session_attr },format: :json
      expect(response).to be_success
    end

    # Checking all recent scores to check order and value
    def check_recent_scores(game_session_id, recent_scores)
      game_session = GameSession.find(game_session_id)
      scores = game_session.game_holder.question_type.session_scores
      recent_scores.each_with_index do |score, i|
        expect(score["value"].to_f).to be_within(0.1).of(scores[i].value)
        expect(score["time_taken"]).to eq(scores[i].time_taken)
        expect(score["correct_count"]).to eq(scores[i].correct_count)
        expect(score["incorrect_count"]).to eq(scores[i].incorrect_count)
        expect(score["seen"]).to eq(scores[i].seen)
        expect(score["passed"]).to eq(scores[i].passed)
        expect(score["failed"]).to eq(scores[i].failed)
      end
    end
    describe "GET #index" do
      context "with no parameters" do
        it "gives first page with given page number" do
          FactoryGirl.create_list(:game_session, 10)
          get :index,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("game_sessions")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
        end
      end

      context "with page params as 2" do
        it "gives page with given page number" do
          FactoryGirl.create_list(:game_session, 20)
          get :index,params:{page:2},format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("game_sessions")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]["page"]).to eq(2)
        end
      end

      context "with limit params as 5" do
        it "gives list of 5 game_sessions" do
          FactoryGirl.create_list(:game_session, 20)
          get :index,params:{limit:5} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("game_sessions")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]["limit"]).to eq(5)
          expect(json["game_sessions"].count).to eq(5)
        end
      end

      context "with search params" do
        it "gives list of game_sessions with search results" do
          # DatabaseCleaner.clean
          game_session_list = FactoryGirl.create_list(:game_session, 10)
          query = game_session_list[0].game_holder_id
          get :index,params:{game_holder_id: query} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("game_sessions")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]).to have_key("search")
          expect(json["meta"]["search"]).to eq(query.to_s)
        end
      end

      context "with slug params" do
        it "gives 1 game_session with given slug" do
          # DatabaseCleaner.clean
          game_session_list = FactoryGirl.create_list(:game_session, 10)
          query = game_session_list[0].user_id
          get :index,params:{user_id: query} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("game_sessions")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]).to have_key("search")
          expect(json["meta"]["search"]).to eq(query.to_s)
          expect(json["game_sessions"].count).to eq(1)
        end
      end
    end
    describe "POST #create" do
      before(:each) do
        # User Creation
        user_login()
        @controller = GameSessionsController.new
      end
      context "with valid attributes" do
        it "gives the new game_session with attributes" do
          request.headers["Authorization"] = @user_json['auth_token']
          post :create,params: { game_session: FactoryGirl.attributes_for(:game_session).except(:user_id) },format: :json
          puts JSON.parse(response.body)
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("game_session")
          expect(json["game_session"]).to have_key("start")
          expect(json["game_session"]).to have_key("finish")
          expect(json["game_session"]).to have_key("session_score")
          expect(json["game_session"]).to have_key("recent_scores")
        end
      end
      context "without slug" do
        it "gives the error" do
          # DatabaseCleaner.clean
          request.headers["Authorization"] = @user_json['auth_token']
          post :create,params: { game_session: FactoryGirl.attributes_for(:game_session).except(:user_id).except(:start) },format: :json
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("error")
        end
      end
      # context "without name" do
      #   it "gives the error" do
      #     # DatabaseCleaner.clean
      #     post :create,params: { game_session: FactoryGirl.attributes_for(:game_session).except(:user_id) },format: :json
      #     expect(response.status).to eq(422)
      #     json = JSON.parse(response.body)
      #     # puts json
      #     expect(json).to have_key("error")
      #   end
      # end
    end
    describe "GET #details" do
      before(:each) do
        user_login()
        @controller = GameSessionsController.new
        @game_session_attr = FactoryGirl.attributes_for(:game_session)
        @game_session_attr[:session_score] = (FactoryGirl.attributes_for(:session_score))
        request.headers["Authorization"] = @user_json['auth_token']
        post :create,params: { game_session: @game_session_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts 'GameSession created before Get Test suite: '+json.to_s
        @game_session_json = json["game_session"]
      end
      context "with valid id" do
        it "gives the existing game_session with attributes" do
          # DatabaseCleaner.clean
          get :details,params: { id: @game_session_json['id'] },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("game_session")
          expect(json["game_session"]).to have_key("start")
          expect(json["game_session"]).to have_key("finish")
          expect(json["game_session"]).to have_key("session_score")
          expect(json["game_session"]["session_score"]).to have_key("value")
          expect(json["game_session"]["session_score"]).to have_key("time_taken")
          expect(json["game_session"]["session_score"]).to have_key("correct_count")
          expect(json["game_session"]["session_score"]).to have_key("incorrect_count")
          expect(json["game_session"]["session_score"]).to have_key("seen")
          expect(json["game_session"]["session_score"]).to have_key("passed")
          expect(json["game_session"]["session_score"]).to have_key("failed")
          # puts json
        end
      end    
      context "with invalid id" do
        it "gives the existing game_session with attributes" do
          # DatabaseCleaner.clean
          get :details,params: { id: @game_session_json['id']+100 },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
          # puts json
        end
      end
    end
    describe "Attempting multiple games" do
      before(:each) do
        # User Creation
        user_login()
        @controller = GameSessionsController.new
      end
      context "with same game_holder" do
        it "calculates correct aggregate scores" do
          # DatabaseCleaner.clean
          @game_holder = FactoryGirl.create(:game_holder)
          3.times do
            create_game_session_call( @user_json['auth_token'], @game_holder.id )
          end
          json = JSON.parse(response.body)
          expect(json).to have_key("game_session")
          expect(json["game_session"]).to have_key("start")
          expect(json["game_session"]).to have_key("finish")
          expect(json["game_session"]).to have_key("session_score")
          expect(json["game_session"]).to have_key("recent_scores")
          expect(json["game_session"]).to have_key("score_rank")
          # puts @user_json['user']['id']
          check_aggregates(User.find(@user_json['user']['id']))
          check_recent_scores(json["game_session"]["id"], json["game_session"]["recent_scores"])
          expect(json["game_session"]["score_rank"]).to eq(GameSession.find(json["game_session"]["id"]).score_rank)
          puts json
        end
      end
      context "with same question_type and multiple game_holders" do
        it "calculates correct aggregate scores" do
          # DatabaseCleaner.clean
          @question_type = FactoryGirl.create(:question_type)
          3.times do
            game_holder = FactoryGirl.create(:game_holder, question_type: @question_type)
            3.times do
              create_game_session_call( @user_json['auth_token'], game_holder.id )
            end
          end
          
          json = JSON.parse(response.body)
          expect(json).to have_key("game_session")
          expect(json["game_session"]).to have_key("start")
          expect(json["game_session"]).to have_key("finish")
          expect(json["game_session"]).to have_key("session_score")
          expect(json["game_session"]).to have_key("recent_scores")
          # puts @user_json['user']['id']
          check_aggregates(User.find(@user_json['user']['id']))
          check_recent_scores(json["game_session"]["id"], json["game_session"]["recent_scores"])
          expect(json["game_session"]["score_rank"]).to eq(GameSession.find(json["game_session"]["id"]).score_rank)
          # puts json
        end
      end
      context "with same sub_topic and multiple question_types" do
        it "calculates correct aggregate scores" do
          # DatabaseCleaner.clean
          sub_topic = FactoryGirl.create(:sub_topic)
          3.times do
            question_type = FactoryGirl.create(:question_type, sub_topic: sub_topic)
            3.times do
              game_holder = FactoryGirl.create(:game_holder, question_type: question_type)
              3.times do
                create_game_session_call( @user_json['auth_token'], game_holder.id )
              end
            end
          end
          
          json = JSON.parse(response.body)
          expect(json).to have_key("game_session")
          expect(json["game_session"]).to have_key("start")
          expect(json["game_session"]).to have_key("finish")
          expect(json["game_session"]).to have_key("session_score")
          expect(json["game_session"]).to have_key("recent_scores")
          # puts @user_json['user']['id']
          check_aggregates(User.find(@user_json['user']['id']))
          check_recent_scores(json["game_session"]["id"], json["game_session"]["recent_scores"])
          expect(json["game_session"]["score_rank"]).to eq(GameSession.find(json["game_session"]["id"]).score_rank)
          # puts json
        end
      end
    end
  end
end
