require 'rails_helper'

RSpec.describe Standard, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:standard)).to be_valid
  end
  describe "Associations" do
    it { should have_many(:chapters) }
    it { should have_many(:topics) }
    it { should have_many(:sub_topics) }
    it { should have_many(:question_types) }
  end
  describe "Acad Profile Associations" do
    it { should have_many(:acad_profiles) }
    it { should have_many(:users) }
    it { should have_many(:acad_entity_scores) }
    it { should have_many(:region_percentile_scores) }
  end
end
