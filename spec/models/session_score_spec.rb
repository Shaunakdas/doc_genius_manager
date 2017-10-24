require 'rails_helper'

RSpec.describe SessionScore, type: :model do
  
  it "has a valid factory" do
    expect(FactoryGirl.create(:session_score)).to be_valid
  end
  describe "Associations" do
    it { should belong_to(:game_session) }
  end
end
