FactoryGirl.define do
  factory :region_percentile_score do
    percentile_count {Faker::Number.number(2)}
    score {Faker::Number.decimal(2)}
    association :acad_entity, factory: :standard
    association :region, factory: :region
  end

end
