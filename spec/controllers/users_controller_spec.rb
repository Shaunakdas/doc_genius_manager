require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET #index" do
    context "with valid attributes" do
      it "gives whole list" do
        DatabaseCleaner.clean
        get :index,format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        puts json

        get :show,format: :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        puts json
        # expect(json).to have_key("directory_items")
        # expect(json['directory_items'].length).not_to eq(0)
      end
    end
  end
end
