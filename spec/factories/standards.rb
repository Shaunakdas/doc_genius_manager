FactoryGirl.define do
  factory :standard do
    name {'Category '+[*('A'..'Z')].sample(8).join}
    # sequence(:name) { |n| "Category #{n}" }
    slug {'category_'+[*('A'..'Z')].sample(8).join}
    # sequence(:slug) { |n| "category_#{n}" }
    add_attribute :sequence, Random.rand(200)
  end

end
