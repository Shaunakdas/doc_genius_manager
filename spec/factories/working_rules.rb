FactoryGirl.define do
  factory :working_rule do
    name {'WorkingRule '+[*('A'..'Z')].sample(8).join}
    slug {'working_rule_'+[*('a'..'z')].sample(8).join}
    add_attribute :sequence, Random.rand(200)
    question_text {'WorkingRule Question Text'+[*('A'..'Z')].sample(8).join}
    association :difficulty_level, factory: :difficulty_level
  end

end
