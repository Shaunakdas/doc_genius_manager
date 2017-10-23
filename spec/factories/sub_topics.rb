FactoryGirl.define do
  factory :sub_topic do
    name {'SubTopic '+[*('A'..'Z')].sample(8).join}
    slug {'sub_topic_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    association :topic, factory: :topic
  end

end
