require 'rails_helper'
require 'spec_helper'
RSpec.describe Api::V1::RegistrationsController, type: :controller do
  describe "POST #create" do
    context "with valid attributes" do
      it "gives the new standard with attributes" do
        create_params = FactoryGirl.attributes_for(:user).slice(:email, :password, :password_confirmation)
        post :sign_up_number,params: {user: create_params }, format: :json
        expect(response).to be_success
        puts response.status
        json = JSON.parse(response.body)
        # expect(json).to have_key("standard")
        # expect(json["standard"]).to have_key("slug")
        # expect(json["standard"]).to have_key("id")
        # expect(json["standard"]).to have_key("name")
        puts json
      end
    end
  end
end
