FactoryGirl.define do
  factory :standard do
    name {'Standard '+[*('A'..'Z')].sample(8).join}
    # sequence(:name) { |n| "Category #{n}" }
    slug {'standard_'+[*('a'..'z')].sample(8).join}
    # sequence(:slug) { |n| "category_#{n}" }
    add_attribute :sequence, Random.rand(200)
  end

end
