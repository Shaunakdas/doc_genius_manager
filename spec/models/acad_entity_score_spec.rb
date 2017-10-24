require 'rails_helper'

RSpec.describe AcadEntityScore, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:acad_entity_score)).to be_valid
  end
  describe "Associations" do
    it { should belong_to(:session_score) }
    it { should belong_to(:acad_entity) }
  end
end
