require 'rails_helper'
require 'spec_helper'
RSpec.describe Api::V1::RegistrationsController, type: :controller do
  def random_standard(standard_json)
    limit = standard_json['limit']
    standard_id = standard_json['result'][rand(limit)]['id']
  end

  describe "POST #sign_up_email" do
    context "with valid attributes" do
      it "gives the new standard with attributes" do
        create_params = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        post :sign_up_email,params: {user: create_params }, format: :json
        expect(response).to be_success
        # puts response.status
        json = JSON.parse(response.body)
        expect(json).to have_key("user")
        # puts json
      end
    end
    context "without email" do
      it "gives the error" do
        # DatabaseCleaner.clean
        post :sign_up_email,params: { user: FactoryGirl.attributes_for(:user).slice(:password, :password_confirmation) },format: :json
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("error")
      end
    end
    context "with incorrect email format" do
      it "gives the error" do
        # DatabaseCleaner.clean
        user_attr = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        user_attr[:email]='shaunak'
        post :sign_up_email,params: { user: user_attr },format: :json
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("error")
      end
    end
    context "with duplicate email" do
      it "gives the error" do
        # DatabaseCleaner.clean
        user_attr = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        post :sign_up_email,params: { user: user_attr },format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("user")
        post :sign_up_email,params: { user: user_attr },format: :json
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("error")
      end
    end
  end
  describe "PUT #fill_up_form" do
    before(:each) do
      @user_attr = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
      post :sign_up_email,params: { user: @user_attr },format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      # puts 'User created before Update Test suite: '+json.to_s
      # puts json
      @user_json = json
    end
    context "with valid id" do
      it "gives the existing user with attributes" do
        # DatabaseCleaner.clean
        updated_attr = FactoryGirl.attributes_for(:user).slice(:sex, :birth, :first_name, :last_name)
        request.headers["Authorization"] = @user_json['auth_token']
        # puts @user_json['auth_token']
        put :update,params: { user:updated_attr },format: :json
        expect(response.status).to eq(204)
      end
    end
    context "with valid id and standard_id" do
      it "gives the existing user with attributes" do
        # DatabaseCleaner.clean
        updated_attr = FactoryGirl.attributes_for(:user).slice(:sex, :birth, :first_name, :last_name)
        request.headers["Authorization"] = @user_json['auth_token']
        updated_attr[:standard_id] = random_standard(@user_json['standards'])
        put :update,params: { user:updated_attr },format: :json
        expect(response.status).to eq(204)
        get :details,params: {},format: :json
        expect(response.status).to eq(200)
        json = JSON.parse(response.body)
        # puts json
      end
    end
  end
  describe "GET #details" do
    before(:each) do
      @user_attr = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
      post :sign_up_email,params: { user: @user_attr },format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      updated_attr = FactoryGirl.attributes_for(:user).slice(:sex, :birth, :first_name, :last_name)
      request.headers["Authorization"] = json['auth_token']
      put :update,params: { user:updated_attr },format: :json
      expect(response.status).to eq(204)
      @user_json = json
      # puts 'Creation json'+json.to_s
    end
    context "with valid auth token" do
      it "gives the existing user with attributes" do
        # DatabaseCleaner.clean
        updated_attr = FactoryGirl.attributes_for(:user).slice(:sex, :birth, :first_name, :last_name)
        request.headers["Authorization"] = @user_json['auth_token']
        # puts @user_json['auth_token']
        get :details,params: {},format: :json
        expect(response.status).to eq(200)
        json = JSON.parse(response.body)
        # puts json
        expect(json).to have_key("user")
        expect(json["user"]).to have_key("email")
        expect(json["user"]).to have_key("id")
        expect(json["user"]).to have_key("first_name")
        expect(json["user"]).to have_key("last_name")
        expect(json["user"]).to have_key("sex")
        expect(json["user"]).to have_key("birth")
      end
    end
    context "with invalid auth token" do
      it "gives the existing user with attributes" do
        # DatabaseCleaner.clean
        updated_attr = FactoryGirl.attributes_for(:user).slice(:sex, :birth, :first_name, :last_name)
        request.headers["Authorization"] = '1'
        # puts @user_json['auth_token']
        get :details,params: {},format: :json
        expect(response.status).to eq(401)
        json = JSON.parse(response.body)
        # puts 'Details json'+json.to_s
        # puts json
        expect(json).to have_key("error")
      end
    end
  end
  describe "POST #login_email" do
    before(:each) do
      @user_attr = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
      post :sign_up_email,params: { user: @user_attr },format: :json
      expect(response).to be_success
      json = JSON.parse(response.body)
      updated_attr = FactoryGirl.attributes_for(:user).slice(:sex, :birth, :first_name, :last_name)
      request.headers["Authorization"] = json['auth_token']
      put :update,params: { user:updated_attr },format: :json
      expect(response.status).to eq(204)
      @user_json = json
    end
    context "with valid attributes" do
      it "gives the new standard with attributes" do
        create_params = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        post :login_email,params: {email: @user_attr[:email], password: @user_attr[:password] }, format: :json
        expect(response).to be_success
        # puts response.status
        json = JSON.parse(response.body)
        expect(json).to have_key("user")
        expect(json).to have_key("auth_token")
        expect(json['user']['id']).to eq(@user_json['user']['id'])
        # puts json
      end
    end
    context "with invalid password" do
      it "gives the unauthorised error" do
        create_params = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        post :login_email,params: {email: @user_attr[:email], password: @user_attr[:password]+'1' }, format: :json
        expect(response.status).to eq(401)
        # puts response.status
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
        # expect(json).to have_key("auth_token")
        # expect(json['user']['id']).to eq(@user_json['user']['id'])
        # puts json
      end
    end
    context "with invalid email" do
      it "gives the not found error" do
        create_params = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        post :login_email,params: {email: @user_attr[:email]+'1', password: @user_attr[:password] }, format: :json
        expect(response.status).to eq(404)
        # puts response.status
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
        # puts json
        
      end
    end
    context "with invalid email format" do
      it "gives the not found error" do
        create_params = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        post :login_email,params: {email: '1', password: @user_attr[:password] }, format: :json
        expect(response.status).to eq(404)
        # puts response.status
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
        # puts json
      end
    end
  end
end
