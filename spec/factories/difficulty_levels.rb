FactoryGirl.define do
  factory :difficulty_level do
    name {'Difficulty Level '+[*('A'..'Z')].sample(8).join}
    # sequence(:name) { |n| "Category #{n}" }
    slug {'difficulty_level__'+[*('a'..'z')].sample(8).join}
    # sequence(:slug) { |n| "category_#{n}" }
    add_attribute :sequence, Random.rand(200)
    value {Random.rand(200)}
  end

end
