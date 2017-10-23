FactoryGirl.define do
  factory :chapter do
    name {'Stream '+[*('A'..'Z')].sample(8).join}
    slug {'stream_'+[*('a'..'z')].sample(8).join}
    sequence_stream Random.rand(200)
    sequence_standard Random.rand(200)
    association :standard, factory: :standard
    association :stream, factory: :stream
  end

end
