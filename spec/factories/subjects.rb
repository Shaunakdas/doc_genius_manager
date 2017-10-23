FactoryGirl.define do
  factory :subject do
    name {'Subject '+[*('A'..'Z')].sample(8).join}
    # sequence(:name) { |n| "Category #{n}" }
    slug {'subject_'+[*('A'..'Z')].sample(8).join}
  end

end
