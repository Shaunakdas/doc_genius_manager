FactoryGirl.define do
  factory :question_type do
    name {'QuestionType '+[*('A'..'Z')].sample(8).join}
    slug {'question_type_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    image_url {Faker::Internet.url('example.com', '/image.png')}
    sub_topic_id {FactoryGirl.create(:sub_topic).id}
    # association :sub_topic, factory: :sub_topic
  end

end
