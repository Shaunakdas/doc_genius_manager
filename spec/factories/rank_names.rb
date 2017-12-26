FactoryGirl.define do
  factory :rank_name do
    display_text {'RankName '+[*('A'..'Z')].sample(8).join}
    slug {'rank_name_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    explainer {'Rank Description '+[*('A'..'Z')].sample(8).join}
  end

end
