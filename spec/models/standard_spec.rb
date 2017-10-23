require 'rails_helper'

RSpec.describe Standard, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:standard)).to be_valid
  end
  describe "Associations" do
    it { should belong_to(:standard) }
    it { should belong_to(:stream) }
  end
end
