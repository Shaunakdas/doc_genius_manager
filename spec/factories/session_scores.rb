FactoryGirl.define do
  factory :session_score do
    value "9.99"
    time_taken {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    correct_count {Faker::Number.number(1)}
    incorrect_count {Faker::Number.number(1)}
    seen {Faker::Boolean.boolean}
    passed {Faker::Boolean.boolean}
    failed {Faker::Boolean.boolean}
    association :game_session, factory: :game_session
  end
end
