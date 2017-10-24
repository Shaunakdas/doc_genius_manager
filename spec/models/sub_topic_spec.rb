require 'rails_helper'

RSpec.describe SubTopic, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:sub_topic)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
  describe "Associations" do
    it { should belong_to(:topic) }
    it { should have_many(:question_types) }
  end
end
