FactoryGirl.define do
  factory :region_percentile_score do
    percentile_count {Faker::Number.number(2)}
    score {Faker::Number.decimal(2)}
    # acad_entity_id {FactoryGirl.create(:acad_entity).id}
    region_id {FactoryGirl.create(:region).id}
    association :acad_entity, factory: :standard
    # association :region, factory: :region
  end

end
