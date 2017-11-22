FactoryGirl.define do
  factory :session_score do
    value {Faker::Number.decimal(3, 2)}
    time_taken {Faker::Number.decimal(2, 3)}
    correct_count {Faker::Number.number(1)}
    incorrect_count {Faker::Number.number(1)}
    seen {Faker::Boolean.boolean}
    passed {Faker::Boolean.boolean}
    # failed {Faker::Boolean.boolean}
    association :game_session, factory: :game_session
  end
end
