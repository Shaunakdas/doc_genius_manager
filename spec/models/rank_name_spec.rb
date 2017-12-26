require 'rails_helper'

RSpec.describe RankName, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:rank_name)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:display_text) }
  end
end
