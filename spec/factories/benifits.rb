FactoryGirl.define do
  factory :benifit do
    name {'Benifit '+[*('A'..'Z')].sample(8).join}
    slug {'benifit_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    image_url {Faker::Internet.url('example.com', '/image.png')}
    explainer {'Benifit Explaination '+[*('A'..'Z')].sample(8).join}
    association :question_type, factory: :question_type
  end

end
