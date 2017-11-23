FactoryGirl.define do
  factory :benefit do
    name {'Benifit '+[*('A'..'Z')].sample(8).join}
    slug {'benefit_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    image_url {Faker::Internet.url('example.com', '/image.png')}
    explainer {'Benifit Explaination '+[*('A'..'Z')].sample(8).join}
  end

end
