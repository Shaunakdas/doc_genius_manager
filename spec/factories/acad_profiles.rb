FactoryGirl.define do
  factory :acad_profile do
    association :acad_entity, factory: :standard
    association :user, factory: :user
  end
end
