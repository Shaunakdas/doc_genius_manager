FactoryGirl.define do
  factory :acad_entity_score do
    average {Faker::Number.decimal(2)}
    maximum {Faker::Number.decimal(2)}
    last {Faker::Number.decimal(2)}
    time_spent {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    passed_count {Faker::Number.number(1)}
    failed_count {Faker::Number.number(1)}
    seen_count {Faker::Number.number(1)}
    percentile {Faker::Number.decimal(2)}
    association :acad_entity, factory: :standard
    association :session_score, factory: :session_score
    association :user, factory: :user
  end

end
