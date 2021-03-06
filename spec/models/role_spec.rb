require 'rails_helper'

RSpec.describe Role, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:role)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
  describe "Associations" do
    it { should have_many(:users) }
  end
end
