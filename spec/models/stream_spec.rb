require 'rails_helper'

RSpec.describe Stream, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:stream)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
  describe "Associations" do
    it { should belong_to(:subject) }
    it { should have_many(:chapters) }
  end
end
