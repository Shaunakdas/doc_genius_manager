module Api::V1
  require 'rails_helper'
  require 'spec_helper'
  RSpec.describe StandardsController, type: :controller do
    def user_login()
      # User Creation
      @controller = RegistrationsController.new
      @user_attr = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
      post :sign_up_email,params: { user: @user_attr },format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      @user_json = json
    end
    def create_questions ques_count,stream_count
      # @questions = (FactoryGirl.create_list(:question_type, ques_count))
      @questions = [FactoryGirl.create(:question_type)]
      @questions.concat(FactoryGirl.create_list(:question_type, ques_count-1, sub_topic: @questions[0].sub_topic))
      @standard = @questions[0].sub_topic.topic.chapter.standard
      @stream_1 = @questions[0].sub_topic.topic.chapter.stream
      
      
      @questions.each do |ques|
        ques.sub_topic.topic.chapter.update_attribute(:stream,@stream_1)
        ques.sub_topic.topic.chapter.update_attribute(:standard,@standard)
      end
      if stream_count == 2
        # Second Stream
        @stream_2 = FactoryGirl.create(:stream)
        chapter_2 = FactoryGirl.create(:chapter, stream: @stream_2, standard: @standard)
        topic_2 = FactoryGirl.create(:topic, chapter: chapter_2)
        sub_topic_2 = FactoryGirl.create(:sub_topic, topic: topic_2)

        half = @questions.length/2
        @first_questions = @questions.slice(0, half)
        @second_questions = @questions.slice(half, 2*half)
        @second_questions.each do |ques|
          ques.update_attribute(:sub_topic,sub_topic_2)
        end
      else
      end
    end
    describe "GET #index" do
      context "with no parameters" do
        it "gives first page with given page number" do
          FactoryGirl.create_list(:standard, 10)
          get :index,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("standards")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
        end
      end
      context "getting list of acad_entities associated with standard" do
        it "gives first page with given page number" do
          std = Standard.first
          # puts std.to_json
          # chapters = FactoryGirl.create_list(:chapter, 2)
          # chapters.each do |chapter|
          #   chapter.standard = std
          #   chapter.sequence_stream = Random.rand(200)
          #   chapter.save!
          #   puts chapter.to_json
          #   topics = FactoryGirl.create_list(:topic, 2)
          #   topics.each do |topic|
          #     topic.chapter = chapter
          #     topic.sequence = Random.rand(200)
          #     topic.save!
          #     sub_topics = FactoryGirl.create_list(:sub_topic, 2)
          #     sub_topics.each do |sub_topic|
          #       sub_topic.topic = topic
          #       sub_topic.sequence = Random.rand(200)
          #       sub_topic.save!
          #       question_types = FactoryGirl.create_list(:question_type, 2)
          #       question_types.each do |question_type|
          #         question_type.sub_topic = sub_topic
          #         question_type.sequence = Random.rand(200)
          #         question_type.save!
          #         puts question_type.to_json
          #       end
          #     end
          #   end
          # end
          std.question_types.each do |question|
            # puts question.to_json
            # puts "    "+question.sub_topic.topic.chapter.sequence_standard.to_s
            # puts "   "+question.sub_topic.topic.sequence.to_s
            # puts "  "+question.sub_topic.sequence.to_s
            # puts question.sequence
          end 
        end
      end
      context "getting list of working_rules associated with working_rule" do
        it "gives first page with given page number" do
          question = QuestionType.last
          # puts question.to_json
          game_holders = GameHolder.last(4)
          # puts game_holders.to_json
          working_rules = WorkingRule.last(4)
          # puts working_rules.to_json
          game_holders.each_with_index do |game,i|
            game.question_type = question
            game.game = working_rules[i]
            game.sequence = Random.rand(200)
            game.save!
            # puts game.to_json
            working_rules[i].sequence = Random.rand(200)
            working_rules[i].save!
          end
          question.game_holders.each do |holder|
            # puts "NEw Holder"
            # puts holder.to_json
            # puts holder.sequence
            rule = WorkingRule.find(holder.game_id)
            # puts rule.to_json
            # puts rule.sequence
          end
          # puts question.games.to_json
        end
      end

      context "with page params as 2" do
        it "gives page with given page number" do
          FactoryGirl.create_list(:standard, 20)
          get :index,params:{page:2},format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("standards")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]["page"]).to eq(2)
        end
      end

      context "with limit params as 5" do
        it "gives list of 5 standards" do
          FactoryGirl.create_list(:standard, 20)
          get :index,params:{limit:5} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("standards")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]["limit"]).to eq(5)
          expect(json["standards"].count).to eq(5)
        end
      end

      context "with search params" do
        it "gives list of standards with search results" do
          # DatabaseCleaner.clean
          standard_list = FactoryGirl.create_list(:standard, 10)
          query = standard_list[0].name
          get :index,params:{search: query} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("standards")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]).to have_key("search")
          expect(json["meta"]["search"]).to eq(query)
        end
      end

      context "with slug params" do
        it "gives 1 standard with given slug" do
          # DatabaseCleaner.clean
          standard_list = FactoryGirl.create_list(:standard, 10)
          query = standard_list[0].slug
          get :index,params:{slug: query} ,format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("standards")
          expect(json["meta"]).to have_key("total_count")
          expect(json["meta"]).to have_key("page")
          expect(json["meta"]).to have_key("limit")
          expect(json["meta"]).to have_key("search")
          expect(json["meta"]["search"]).to eq(query)
          expect(json["standards"].count).to eq(1)
        end
      end
    end
    describe "POST #create" do
      context "with valid attributes" do
        it "gives the new standard with attributes" do
          # DatabaseCleaner.clean
          post :create,params: { standard: FactoryGirl.attributes_for(:standard) },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("standard")
          expect(json["standard"]).to have_key("slug")
          expect(json["standard"]).to have_key("id")
          expect(json["standard"]).to have_key("name")
          # puts json
        end
      end
      context "without slug" do
        it "gives the error" do
          # DatabaseCleaner.clean
          post :create,params: { standard: FactoryGirl.attributes_for(:standard).except(:slug) },format: :json
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("error")
        end
      end
      context "with duplicate slug" do
        it "gives the error" do
          # DatabaseCleaner.clean
          standard_attr = FactoryGirl.attributes_for(:standard)
          post :create,params: { standard: standard_attr },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("standard")
          post :create,params: { standard: standard_attr },format: :json
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("error")
        end
      end
      context "without name" do
        it "gives the error" do
          # DatabaseCleaner.clean
          post :create,params: { standard: FactoryGirl.attributes_for(:standard).except(:name) },format: :json
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("error")
        end
      end
    end
    describe "GET #details" do
      before(:each) do
        @standard_attr = FactoryGirl.attributes_for(:standard)
        post :create,params: { standard: @standard_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts 'Standard created before Get Test suite: '+json.to_s
        @standard_json = json["standard"]
      end
      context "with valid id" do
        it "gives the existing standard with attributes" do
          # DatabaseCleaner.clean
          get :details,params: { id: @standard_json['id'] },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("standard")
          expect(json["standard"]).to have_key("slug")
          expect(json["standard"]).to have_key("id")
          expect(json["standard"]).to have_key("name")
          expect(json["standard"]).to have_key("sequence")
          # puts json
        end
      end    
      context "with invalid id" do
        it "gives the existing standard with attributes" do
          # DatabaseCleaner.clean
          get :details,params: { id: @standard_json['id']+100 },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
          # puts json
        end
      end
    end
    describe "PUT #update" do
      before(:each) do
        @standard_attr = FactoryGirl.attributes_for(:standard)
        post :create,params: { standard: @standard_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts 'Standard created before Update Test suite: '+json.to_s
        @standard_json = json["standard"]
      end
      context "with valid id" do
        it "gives the existing standard with attributes" do
          # DatabaseCleaner.clean
          updated_attr = FactoryGirl.attributes_for(:standard)
          # puts updated_attr
          put :update,params: { id: @standard_json['id'],standard:updated_attr },format: :json
          expect(response.status).to eq(204)
        end
      end 
      context "with invalid id" do
        it "gives error" do
          # DatabaseCleaner.clean
          put :details,params: { id: @standard_json['id']+100 },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
          # puts json
        end
      end
    end

    describe "DELETE #delete" do
      before(:each) do
        @standard_attr = FactoryGirl.attributes_for(:standard)
        post :create,params: { standard: @standard_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts 'Standard created before Delete Test suite: '+json.to_s
        @standard_json = json["standard"]
      end
      context "with valid id" do
        it "gives success response" do
          # DatabaseCleaner.clean
          # puts updated_attr
          delete :delete,params: { id: @standard_json['id']},format: :json
          expect(response.status).to eq(200)
          json = JSON.parse(response.body)
          expect(json).to have_key("success")
          # puts json
          get :details,params: { id: @standard_json['id'] },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
        end
      end    
      context "with invalid id" do
        it "gives error" do
          # DatabaseCleaner.clean
          put :delete,params: { id: @standard_json['id']+100 },format: :json
          expect(response.status).to eq(404)
          json = JSON.parse(response.body)
          expect(json).to have_key("error")
          # puts json
        end
      end
    end
    describe "GET #homepage",focus: true do
      before(:each) do
        create_questions(4,1)
        user_login()
        @controller = StandardsController.new
        @user = User.find(@user_json['user']['id'])
        @user.update_acad_entity({standard_id: @standard.id})
      end
      context "with valid id" do
        it "gives the homepage with 4 question_types" do
          # DatabaseCleaner.clean
          request.headers["Authorization"] = @user_json['auth_token']
          get :homepage,params: { },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          expect(json).to have_key("homepage")
          expect(json["homepage"]).to have_key("first_name")
          expect(json["homepage"]).to have_key("id")
          expect(json["homepage"]).to have_key("last_name")
          expect(json["homepage"]).to have_key("email")
          expect(json["homepage"]).to have_key("sex")
          expect(json["homepage"]["standard"]["id"]).to eq(@standard.id)
          expect(json["homepage"]["recent_questions"].count).to eq(@questions.count)
          @ques_ids = @questions.map{|x| x[:id]}
          json["homepage"]["recent_questions"].each do |question|
            expect(@ques_ids).to include(question['id'])
          end
        end
      end
    end
    describe "GET #all_questions with single stream",focus: true do
      before(:each) do
        create_questions(4,1)
        user_login()
        @controller = StandardsController.new
        @user = User.find(@user_json['user']['id'])
        @user.update_acad_entity({standard_id: @standard.id})
      end
      context "with one stream" do
        it "gives the homepage with 4 question_types" do
          # DatabaseCleaner.clean
          request.headers["Authorization"] = @user_json['auth_token']
          get :streamwise_questions,params: { },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("streams")
          expect(json["streams"].count).to eq(1)
          expect(json["streams"][0]['id']).to eq(@stream_1.id)
          expect(json["streams"][0]['question_types'].count).to eq(4)
          @ques_ids = @questions.map{|x| x[:id]}
          json["streams"][0]['question_types'].each do |question|
            expect(@ques_ids).to include(question['id'])
          end
        end
      end
    end
    describe "GET #all_questions with multiple streams",focus: true do
      before(:each) do
        create_questions(8,2)
        user_login()
        @controller = StandardsController.new
        @user = User.find(@user_json['user']['id'])
        @user.update_acad_entity({standard_id: @standard.id})
      end
      context "with one stream" do
        it "gives the homepage with 4 question_types" do
          # DatabaseCleaner.clean
          request.headers["Authorization"] = @user_json['auth_token']
          get :streamwise_questions,params: { },format: :json
          expect(response).to be_success
          json = JSON.parse(response.body)
          # puts json
          expect(json).to have_key("streams")
          expect(json["streams"].count).to eq(2)
          @stream_ids = [@stream_1.id, @stream_2.id]
          expect(@stream_ids).to include(json["streams"][0]['id'])
          expect(@stream_ids).to include(json["streams"][1]['id'])
          expect(json["streams"][0]['question_types'].count).to eq(4)
          @ques_ids = @questions.map{|x| x[:id]}
          json["streams"][0]['question_types'].each do |question|
            expect(@ques_ids).to include(question['id'])
          end
          json["streams"][1]['question_types'].each do |question|
            expect(@ques_ids).to include(question['id'])
          end
        end
      end
    end
  end
end