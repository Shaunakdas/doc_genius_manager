FactoryGirl.define do
  factory :score_structure do
    game_holder nil
limiter_time_question 1
limiter_time_game 1
limiter_option 1
limiter_question 1
limiter_lives 1
marks_normal_attempt 1
marks_normal_time 1
marks_speedy_time_limit 1
marks_speedy_max 1
marks_complete_set 1
marks_remaining_lives 1
marks_actual_answer 1
marks_consistency_bonus 1
marks_remaining_time 1
star_threshold_2 1
star_threshold_3 1
display_report_accuracy false
display_report_content false
display_remaining_lives false
display_speedy_answer false
display_perfect_set false
display_longest_streak false
display_accurate_answer false
display_errors false
display_remaining_time false
  end

end
