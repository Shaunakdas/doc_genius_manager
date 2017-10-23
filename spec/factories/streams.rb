FactoryGirl.define do
  factory :stream do
    name {'Stream '+[*('A'..'Z')].sample(8).join}
    slug {'stream_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    association :subject, factory: :subject
  end

end
