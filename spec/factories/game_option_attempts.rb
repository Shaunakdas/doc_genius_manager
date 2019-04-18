FactoryGirl.define do
  factory :game_option_attempt do
    is_attempted false
is_attempted_correctly false
user_input "MyString"
time_attempt 1
game_option nil
game_question_attempt nil
  end

end
