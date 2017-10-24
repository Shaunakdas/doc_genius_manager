FactoryGirl.define do
  factory :user_region do
    registration_date {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    association :user, factory: :user
    association :region, factory: :region
  end

end
