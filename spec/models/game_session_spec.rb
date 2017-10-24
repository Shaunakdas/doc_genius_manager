require 'rails_helper'

RSpec.describe GameSession, type: :model do
  
  it "has a valid factory" do
    expect(FactoryGirl.create(:game_session)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:start) }
  end
  describe "Associations" do
    it { should belong_to(:game_holder) }
    it { should belong_to(:user) }
  end
end
