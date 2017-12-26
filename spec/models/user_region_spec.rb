require 'rails_helper'

RSpec.describe UserRegion, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:user_region)).to be_valid
  end
  describe "Associations" do
    it { should belong_to(:region) }
    it { should belong_to(:user) }
  end
end
