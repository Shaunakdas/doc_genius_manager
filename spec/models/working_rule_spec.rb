require 'rails_helper'

RSpec.describe WorkingRule, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:working_rule)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
  describe "Associations" do
    it { should belong_to(:difficulty_level) }
  end
end
