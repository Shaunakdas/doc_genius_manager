require 'rails_helper'
require 'spec_helper'
RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET #index" do
    context "with valid attributes" do
      it "gives whole list" do
        DatabaseCleaner.clean
        get :index,format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        puts json

        # get :show,format: :json
        # expect(response).to be_success
        # json = JSON.parse(response.body)
        # puts json
        # expect(json).to have_key("directory_items")
        # expect(json['directory_items'].length).not_to eq(0)
      end
    end
  end
  describe "POST #create" do
    context "with valid attributes" do
      it "gives the new user with attributes" do
        DatabaseCleaner.clean
        post :create,params: { user: FactoryGirl.attributes_for(:user) },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json).to have_key("user")
        expect(json["user"]).to have_key("email")
        expect(json["user"]).to have_key("id")
        expect(json["user"]).to have_key("first_name")
        expect(json["user"]).to have_key("last_name")
        # puts json
      end
    end
    context "without email" do
      it "gives the error" do
        DatabaseCleaner.clean
        post :create,params: { user: FactoryGirl.attributes_for(:user).except(:email) },format: :json
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("error")
      end
    end
    context "with incorrect email format" do
      it "gives the error" do
        DatabaseCleaner.clean
        user_attr = FactoryGirl.attributes_for(:user)
        user_attr[:email]='shaunak'
        post :create,params: { user: user_attr },format: :json
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("error")
      end
    end
    context "with duplicate email" do
      it "gives the error" do
        DatabaseCleaner.clean
        user_attr = FactoryGirl.attributes_for(:user)
        post :create,params: { user: user_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("user")
        post :create,params: { user: user_attr },format: :json
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("error")
      end
    end
    context "without first_name" do
      it "gives the error" do
        DatabaseCleaner.clean
        post :create,params: { user: FactoryGirl.attributes_for(:user).except(:first_name) },format: :json
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("error")
      end
    end
  end
  describe "GET #details" do
    before(:each) do
      @user_attr = FactoryGirl.attributes_for(:user)
      post :create,params: { user: @user_attr },format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      # puts 'User created before Get Test suite: '+json.to_s
      @user_json = json["user"]
    end
    context "with valid id" do
      it "gives the existing user with attributes" do
        DatabaseCleaner.clean
        get :details,params: { id: @user_json['id'] },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json).to have_key("user")
        expect(json["user"]).to have_key("email")
        expect(json["user"]).to have_key("id")
        expect(json["user"]).to have_key("first_name")
        expect(json["user"]).to have_key("last_name")
        # puts json
      end
    end    
    context "with invalid id" do
      it "gives the existing user with attributes" do
        DatabaseCleaner.clean
        get :details,params: { id: @user_json['id']+100 },format: :json
        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
        # puts json
      end
    end
  end
  describe "PUT #update" do
    before(:each) do
      @user_attr = FactoryGirl.attributes_for(:user)
      post :create,params: { user: @user_attr },format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      # puts 'User created before Update Test suite: '+json.to_s
      @user_json = json["user"]
    end
    context "with valid id" do
      it "gives the existing user with attributes" do
        DatabaseCleaner.clean
        updated_attr = FactoryGirl.attributes_for(:user)
        # puts updated_attr
        put :update,params: { id: @user_json['id'],user:updated_attr },format: :json
        expect(response.status).to eq(204)
      end
    end 
    context "with valid id and incorrect email" do
      it "gives error" do
        DatabaseCleaner.clean
        updated_attr = FactoryGirl.attributes_for(:user)
        updated_attr[:email] = ''
        # puts updated_attr
        put :update,params: { id: @user_json['id'],user:updated_attr },format: :json
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
      end
    end    
    context "with invalid id" do
      it "gives error" do
        DatabaseCleaner.clean
        put :details,params: { id: @user_json['id']+100 },format: :json
        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
        # puts json
      end
    end
  end

  describe "DELETE #delete" do
    before(:each) do
      @user_attr = FactoryGirl.attributes_for(:user)
      post :create,params: { user: @user_attr },format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      puts 'User created before Delete Test suite: '+json.to_s
      @user_json = json["user"]
    end
    context "with valid id" do
      it "gives success response" do
        DatabaseCleaner.clean
        # puts updated_attr
        delete :delete,params: { id: @user_json['id']},format: :json
        expect(response.status).to eq(200)
        json = JSON.parse(response.body)
        expect(json).to have_key("success")
        puts json
        get :details,params: { id: @user_json['id'] },format: :json
        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
      end
    end    
    context "with invalid id" do
      it "gives error" do
        DatabaseCleaner.clean
        put :delete,params: { id: @user_json['id']+100 },format: :json
        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
        # puts json
      end
    end
  end
end
