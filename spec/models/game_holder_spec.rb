require 'rails_helper'

RSpec.describe GameHolder, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:game_holder)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
  describe "Associations" do
    it { should belong_to(:question_type) }
    it { should belong_to(:game) }
  end
end