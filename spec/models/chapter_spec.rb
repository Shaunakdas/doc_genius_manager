require 'rails_helper'

RSpec.describe Chapter, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:chapter)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
  describe "Associations" do
    it { should belong_to(:standard) }
    it { should belong_to(:stream) }
    it { should have_many(:topics) }
  end
  describe "Acad Profile Associations" do
    it { should have_many(:acad_profiles) }
    it { should have_many(:users) }
    it { should have_many(:acad_entity_scores) }
  end
end
