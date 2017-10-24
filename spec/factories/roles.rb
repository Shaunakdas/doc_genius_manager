FactoryGirl.define do
  factory :role do
    name {'Role '+[*('A'..'Z')].sample(8).join}
    slug {'role_'+[*('a'..'z')].sample(8).join}
  end

end
