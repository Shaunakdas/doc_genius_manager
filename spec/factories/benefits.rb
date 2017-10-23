FactoryGirl.define do
  factory :benefit do
    name {'Benefit '+[*('A'..'Z')].sample(8).join}
    slug {'benefit_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    image_url {Faker::Internet.url('example.com', '/image.png')}
    explainer {'Benefit Explaination '+[*('A'..'Z')].sample(8).join}
  end

end
