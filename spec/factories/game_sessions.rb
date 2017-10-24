FactoryGirl.define do
  factory :game_session do
    start {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    finish {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    association :game_holder, factory: :game_holder
    association :user, factory: :user
  end

end
