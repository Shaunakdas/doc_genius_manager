require 'rails_helper'

RSpec.describe QuestionType, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:question_type)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
  describe "Associations" do
    it { should belong_to(:sub_topic) }
    it { should have_many(:game_holders) }
    it { should have_many(:games) }
  end
end
