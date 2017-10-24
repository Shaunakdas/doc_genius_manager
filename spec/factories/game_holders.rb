FactoryGirl.define do
  factory :game_holder do
    name {'GameHolder '+[*('A'..'Z')].sample(8).join}
    slug {'game_holder_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    image_url {Faker::Internet.url('example.com', '/image.png')}
    association :question_type, factory: :question_type
    association :game, factory: :working_rule
  end

end
