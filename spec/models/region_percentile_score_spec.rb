require 'rails_helper'

RSpec.describe RegionPercentileScore, type: :model do
  
  it "has a valid factory" do
    expect(FactoryGirl.create(:region_percentile_score)).to be_valid
  end
  describe "Associations" do
    it { should belong_to(:region) }
    it { should belong_to(:acad_entity) }
  end
end
