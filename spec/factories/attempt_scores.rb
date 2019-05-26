FactoryGirl.define do
  factory :attempt_score do
    attempt_item nil
displayed false
time_spent 1
passed false
tap_count 1
user_input "MyString"
correct_count 1
star_count 1
normal_marks 1
speedy_marks 1
complete_set_marks 1
actual_answer_marks 1
consistency_marks 1
remaining_time_marks 1
remaining_lives_marks 1
  end

end
