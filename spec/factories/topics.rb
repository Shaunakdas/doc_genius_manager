FactoryGirl.define do
  factory :topic do
    name {'Topic '+[*('A'..'Z')].sample(8).join}
    slug {'topic_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    # association :chapter, factory: :chapter
    chapter_id {FactoryGirl.create(:chapter).id}
  end

end
