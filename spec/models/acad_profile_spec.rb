require 'rails_helper'

RSpec.describe AcadProfile, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:game_holder)).to be_valid
  end
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:acad_entity) }
  end
end
