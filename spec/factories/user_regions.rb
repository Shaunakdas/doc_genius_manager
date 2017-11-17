FactoryGirl.define do
  factory :user_region do
    registration_date {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    user_id {FactoryGirl.create(:user).id}
    region_id {FactoryGirl.create(:region).id}
    # association :user, factory: :user
    # association :region, factory: :region
  end

end
