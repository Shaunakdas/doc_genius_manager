require 'rails_helper'

RSpec.describe Benefit, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:benefit)).to be_valid
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
