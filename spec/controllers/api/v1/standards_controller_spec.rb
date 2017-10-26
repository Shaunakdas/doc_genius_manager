require 'rails_helper'
require 'spec_helper'
RSpec.describe Api::V1::StandardsController, type: :controller do
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
end
