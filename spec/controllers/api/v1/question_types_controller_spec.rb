require 'rails_helper'
require 'spec_helper'
module Api::V1
  RSpec.describe QuestionTypesController, type: :controller do

    def create_game_session_call auth, game_holder_id
      @controller = GameSessionsController.new
      @game_session_attr = FactoryGirl.attributes_for(:game_session).except(:user_id)
      @game_session_attr[:session_score] = (FactoryGirl.attributes_for(:session_score))
      @game_session_attr[:game_holder_id] = game_holder_id
      request.headers["Authorization"] = auth
      post :create,params: { game_session: @game_session_attr },format: :json
      expect(response).to be_success
      @game_sessions << GameSession.find(JSON.parse(response.body)["game_session"]["id"].to_i)
    end

    describe "GET #index" do
      context "with no parameters" do
        it "gives first page with given page number" do
          FactoryGirl.create_list(:question_type, 10)
          get :index,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("question_types")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
        end
      end

      context "with page params as 2" do
        it "gives page with given page number" do
          FactoryGirl.create_list(:question_type, 20)
          get :index,params:{page:2},format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("question_types")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]["page"]).to eq(2)
        end
      end

      context "with limit params as 5" do
        it "gives list of 5 question_types" do
          FactoryGirl.create_list(:question_type, 20)
          get :index,params:{limit:5} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("question_types")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]["limit"]).to eq(5)
          expect(json["question_types"].count).to eq(5)
        end
      end

      context "with search params" do
        it "gives list of question_types with search results" do
          # DatabaseCleaner.clean
          question_type_list = FactoryGirl.create_list(:question_type, 10)
          query = question_type_list[0].name
          get :index,params:{search: query} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("question_types")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]).to have_key("search")
          expect(json["meta"]["search"]).to eq(query)
        end
      end

      context "with slug params" do
        it "gives 1 question_type with given slug" do
          # DatabaseCleaner.clean
          question_type_list = FactoryGirl.create_list(:question_type, 10)
          query = question_type_list[0].slug
          get :index,params:{slug: query} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("question_types")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]).to have_key("search")
          expect(json["meta"]["search"]).to eq(query)
          expect(json["question_types"].count).to eq(1)
        end
      end
    end
    describe "POST #create" do
      context "with valid attributes" do
        it "gives the new question_type with attributes" do
          # DatabaseCleaner.clean
          post :create,params: { question_type: FactoryGirl.attributes_for(:question_type) },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("question_type")
          expect(json["question_type"]).to have_key("slug")
          expect(json["question_type"]).to have_key("id")
          expect(json["question_type"]).to have_key("name")
          # puts json
        end
      end
      context "without slug" do
        it "gives the error" do
          # DatabaseCleaner.clean
          post :create,params: { question_type: FactoryGirl.attributes_for(:question_type).except(:slug) },format: :json
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("error")
        end
      end
      context "with duplicate slug" do
        it "gives the error" do
          # DatabaseCleaner.clean
          question_type_attr = FactoryGirl.attributes_for(:question_type)
          post :create,params: { question_type: question_type_attr },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("question_type")
          post :create,params: { question_type: question_type_attr },format: :json
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("error")
        end
      end
      context "without name" do
        it "gives the error" do
          # DatabaseCleaner.clean
          post :create,params: { question_type: FactoryGirl.attributes_for(:question_type).except(:name) },format: :json
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("error")
        end
      end
    end
    describe "GET #details" do
      before(:each) do
        @question_type_attr = FactoryGirl.attributes_for(:question_type)
        post :create,params: { question_type: @question_type_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts 'QuestionType created before Get Test suite: '+json.to_s
        @question_type_json = json["question_type"]
      end
      context "with valid id" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          get :details,params: { id: @question_type_json['id'] },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("question_type")
          expect(json["question_type"]).to have_key("slug")
          expect(json["question_type"]).to have_key("id")
          expect(json["question_type"]).to have_key("name")
          expect(json["question_type"]).to have_key("sequence")
          # puts json
        end
      end    
      context "with invalid id" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          get :details,params: { id: @question_type_json['id']+100 },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
          # puts json
        end
      end
    end
    describe "PUT #update" do
      before(:each) do
        @question_type_attr = FactoryGirl.attributes_for(:question_type)
        post :create,params: { question_type: @question_type_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts 'QuestionType created before Update Test suite: '+json.to_s
        @question_type_json = json["question_type"]
      end
      context "with valid id" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          updated_attr = FactoryGirl.attributes_for(:question_type)
          # puts updated_attr
          put :update,params: { id: @question_type_json['id'],question_type:updated_attr },format: :json
          expect(response.status).to eq(204)
        end
      end 
      context "with invalid id" do
        it "gives error" do
          # DatabaseCleaner.clean
          put :details,params: { id: @question_type_json['id']+100 },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
          # puts json
        end
      end
    end

    describe "DELETE #delete" do
      before(:each) do
        @question_type_attr = FactoryGirl.attributes_for(:question_type)
        post :create,params: { question_type: @question_type_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts 'QuestionType created before Delete Test suite: '+json.to_s
        @question_type_json = json["question_type"]
      end
      context "with valid id" do
        it "gives success response" do
          # DatabaseCleaner.clean
          # puts updated_attr
          delete :delete,params: { id: @question_type_json['id']},format: :json
          expect(response.status).to eq(200)
          json = JSON.parse(response.body)
          expect(json).to have_key("success")
          # puts json
          get :details,params: { id: @question_type_json['id'] },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
        end
      end    
      context "with invalid id" do
        it "gives error" do
          # DatabaseCleaner.clean
          put :delete,params: { id: @question_type_json['id']+100 },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
          # puts json
        end
      end
    end

    describe "GET #show" do
      before(:each) do
        @game_sessions =[]
        # Question Type creation
        @question_type = FactoryGirl.create(:question_type)
        # User Creation
        @controller = RegistrationsController.new
        @user_attr = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        post :sign_up_email,params: { user: @user_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        @user_json = json
        @controller = QuestionTypesController.new
      end
      context "with valid id" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          request.headers["Authorization"] = @user_json['auth_token']
          get :show,params: { id: @question_type.id },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("question_type")
          ques_json = json["question_type"]
          expect(ques_json).to include("slug","id","name","sequence","sub_topic","top_score","scores","challenges","benifits","current")
          expect(ques_json["scores"]).to include("top","recent")
          expect(ques_json["sub_topic"]).to include("slug","id","name","sequence","topic")
          expect(ques_json["sub_topic"]["topic"]).to include("slug","id","name","sequence","chapter")
        end
      end  
      context "with valid id and benifits" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          @benifits =[]
          3.times do
            @benifits << FactoryGirl.create(:benifit, question_type: @question_type, sequence: Random.rand(200))
          end
          @benifits = @benifits.sort_by { |benifit| benifit.sequence }
          request.headers["Authorization"] = @user_json['auth_token']
          get :show,params: { id: @question_type.id },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          puts json
          expect(json).to have_key("question_type")
          ques_json = json["question_type"]
          ques_json['benifits'].each_with_index do |benifit,i|
            expect(benifit).to eq( 
                {
                  'id' => @benifits[i].id,
                  'slug' => @benifits[i].slug,
                  'name' => @benifits[i].name,
                  'sequence' => @benifits[i].sequence,
                  'explainer' => @benifits[i].explainer,
                  'image_url' => @benifits[i].image_url
                }
              ) 
          end
        end
      end
      context "with valid id and a working rule" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          working_rule = FactoryGirl.create(:working_rule)
          game_holder = FactoryGirl.create(:game_holder, game: working_rule, question_type: @question_type)
          request.headers["Authorization"] = @user_json['auth_token']
          get :show,params: { id: @question_type.id },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("question_type")
          ques_json = json["question_type"]
          expect(ques_json['current']).to eq( 
            {
              'id' => working_rule.id,
              'slug' => working_rule.slug,
              'name' => working_rule.name,
              'sequence' => working_rule.sequence,
              'question_text' => working_rule.question_text
            }
          ) 
        end
      end
      context "after 1 game_session" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          @game_holder = FactoryGirl.create(:game_holder, question_type: @question_type)
          create_game_session_call( @user_json['auth_token'], @game_holder.id )
          @controller = QuestionTypesController.new
          request.headers["Authorization"] = @user_json['auth_token']
          get :show,params: { id: @question_type.id },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          puts json
          expect(json).to have_key("question_type")
          ques_json = json["question_type"]
          score = @game_sessions[0].session_score
          expect(ques_json["top_score"].to_f).to be_within(0.1).of(score.value)
          expect(ques_json["scores"]['top'][0]['value'].to_f).to be_within(0.1).of(score.value)
          expect(ques_json["scores"]['top'][0]['created_at']).to eq(score.created_at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ"))
          expect(ques_json["scores"]['recent'][0]['value'].to_f).to be_within(0.1).of(score.value)
          expect(ques_json["scores"]['recent'][0]['created_at']).to eq(score.created_at.strftime("%Y-%m-%dT%H:%M:%S.%3NZ"))
        end
      end 
      context "after 3 game_session" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          @game_holder = FactoryGirl.create(:game_holder, question_type: @question_type)
          3.times do
            create_game_session_call( @user_json['auth_token'], @game_holder.id )
          end
          @controller = QuestionTypesController.new
          request.headers["Authorization"] = @user_json['auth_token']
          get :show,params: { id: @question_type.id },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          puts json
          expect(json).to have_key("question_type")
          ques_json = json["question_type"]
          scores = []
          @game_sessions.each do |game_session|
            scores << game_session.session_score
          end
          sorted_value = scores.sort_by { |score| -score.value }
          sorted_created = scores.sort_by { |score| score.created_at }.reverse
          ques_json["scores"]['top'].each_with_index do |score,i|
            expect(score['value'].to_f).to be_within(0.1).of(sorted_value[i].value)
          end
          ques_json["scores"]['recent'].each_with_index do |score,i|
            expect(score['value'].to_f).to be_within(0.1).of(sorted_created[i].value)
          end
          
        end
      end 
      context "after 10 game_session" do
        it "gives the existing question_type with attributes" do
          # DatabaseCleaner.clean
          @game_holder = FactoryGirl.create(:game_holder, question_type: @question_type)
          10.times do
            create_game_session_call( @user_json['auth_token'], @game_holder.id )
          end
          @controller = QuestionTypesController.new
          request.headers["Authorization"] = @user_json['auth_token']
          get :show,params: { id: @question_type.id },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          puts json
          expect(json).to have_key("question_type")
          ques_json = json["question_type"]
          scores = []
          @game_sessions.each do |game_session|
            scores << game_session.session_score
          end
          sorted_value = scores.sort_by { |score| -score.value }
          sorted_created = scores.sort_by { |score| score.created_at }.reverse
          ques_json["scores"]['top'].each_with_index do |score,i|
            expect(score['value'].to_f).to be_within(0.1).of(sorted_value[i].value)
          end
          ques_json["scores"]['recent'].each_with_index do |score,i|
            expect(score['value'].to_f).to be_within(0.1).of(sorted_created[i].value)
          end
          
        end
      end 
    end
  end
end
