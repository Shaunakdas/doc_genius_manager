FactoryGirl.define do
  factory :chapter do
    name {'Chapter '+[*('A'..'Z')].sample(8).join}
    slug {'chapter_'+[*('a'..'z')].sample(8).join}
    sequence_stream Random.rand(200)
    sequence_standard Random.rand(200)
    standard_id {FactoryGirl.create(:standard).id}
    stream_id {FactoryGirl.create(:stream).id}
    # association :standard, factory: :standard
    # association :stream, factory: :stream
  end

end
