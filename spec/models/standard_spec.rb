require 'rails_helper'

RSpec.describe Standard, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:standard)).to be_valid
  end

  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_presence_of(:name) }
end
