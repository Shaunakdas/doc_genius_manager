require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  # it { is_expected.to validate_presence_of(:first_name) }
  # it { is_expected.to validate_presence_of(:last_name) }
  # it { is_expected.to validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  # it { should validate_uniqueness_of(:mobile_number).case_insensitive }

  describe "Associations" do
    it { should belong_to(:role) }
    it { should have_many(:acad_profiles) }
    it { should have_many(:game_sessions) }
    it { should have_many(:user_regions) }
    it { should have_many(:acad_entity_scores) }
  end
end
