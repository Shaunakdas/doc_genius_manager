require 'rails_helper'

RSpec.describe Region, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:region, :with_parent)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "Associations" do
    it { should belong_to(:parent_region) }
    it { should have_many(:sub_regions) }
    it { should have_many(:user_regions) }
    it { should have_many(:region_percentile_scores) }
  end
end
