require 'rails_helper'

RSpec.describe Topic, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:topic)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
  describe "Associations" do
    it { should belong_to(:chapter) }
    it { should have_many(:sub_topics) }
  end
  describe "Acad Profile Associations" do
    it { should have_many(:acad_profiles) }
    it { should have_many(:users) }
    it { should have_many(:acad_entity_scores) }
  end
end
