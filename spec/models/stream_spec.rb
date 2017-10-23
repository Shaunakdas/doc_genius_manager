require 'rails_helper'

RSpec.describe Stream, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:stream)).to be_valid
  end

  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_presence_of(:name) }
end
