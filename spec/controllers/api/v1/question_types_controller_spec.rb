require 'rails_helper'
require 'spec_helper'
module Api::V1
  RSpec.describe QuestionTypesController, type: :controller do
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
        it "gives the new question_type with attributes", :focus => true do
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
    describe "GET #show" do
      before(:each) do
        # Question Type creation
        @question_type_attr = FactoryGirl.attributes_for(:question_type)
        post :create,params: { question_type: @question_type_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts 'QuestionType created before Get Test suite: '+json.to_s
        @question_type_json = json["question_type"]
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
        it "gives the existing question_type with attributes", :focus => true do
          # DatabaseCleaner.clean
          request.headers["Authorization"] = @user_json['auth_token']
          get :show,params: { id: @question_type_json['id'] },format: :json
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
        it "gives the existing question_type with attributes", :focus => true do
          # DatabaseCleaner.clean
          request.headers["Authorization"] = @user_json['auth_token']
          get :show,params: { id: @question_type_json['id']+100 },format: :json
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
  end
end
