require 'rails_helper'

RSpec.describe DifficultyLevel, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:difficulty_level)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
