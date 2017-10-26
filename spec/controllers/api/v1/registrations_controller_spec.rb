require 'rails_helper'
require 'spec_helper'
RSpec.describe Api::V1::RegistrationsController, type: :controller do
  describe "POST #create" do
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
  describe "PUT #update" do
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
        headers = { Authorization: @user_json['auth_token']  }
        updated_attr = FactoryGirl.attributes_for(:user).slice(:sex, :registration_method, :birth, :first_name, :last_name)
        # puts updated_attr
        # request.headers.merge! headers
        request.headers["Authorization"] = @user_json['auth_token']
        # puts @user_json['auth_token']
        put :update,params: { user:updated_attr },format: :json
        expect(response.status).to eq(204)
      end
    end 
    # context "with valid id and incorrect email" do
    #   it "gives error" do
    #     # DatabaseCleaner.clean
    #     updated_attr = FactoryGirl.attributes_for(:user)
    #     updated_attr[:email] = ''
    #     # puts updated_attr
    #     put :update,params: { id: @user_json['id'],user:updated_attr },format: :json
    #     expect(response.status).to eq(422)
    #     json = JSON.parse(response.body)
    #     expect(json).to have_key("error")
    #   end
    # end    
    # context "with invalid id" do
    #   it "gives error" do
    #     # DatabaseCleaner.clean
    #     put :details,params: { id: @user_json['id']+100 },format: :json
    #     expect(response.status).to eq(404)
    #     json = JSON.parse(response.body)
    #     expect(json).to have_key("error")
    #     # puts json
    #   end
    # end
  end
end
