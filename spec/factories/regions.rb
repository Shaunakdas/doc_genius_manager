FactoryGirl.define do
  factory :region do
    name {'Region '+[*('A'..'Z')].sample(8).join}
    slug {'region_'+[*('a'..'z')].sample(8).join}
    region_type {"Region Type"}
    trait :with_parent do
      association :parent_region, factory: :region
    end
  end

end
