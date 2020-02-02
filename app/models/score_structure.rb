class ScoreStructure < ApplicationRecord
  belongs_to :game_holder


  def score_algo
    return {
      limiter: limiter,
      marks: marks,
      end_screen: end_screen,
    }
  end

  def limiter
    {
      time: {
        per_question: limiter_time_question,
        per_game: limiter_time_game
      },
      options: limiter_option,
      questions: limiter_question,
      lives: limiter_lives
    }
  end

  def marks
    {
      normal:{
        attempt: marks_normal_attempt,
        time: marks_normal_time
      },
      speedy: {
        time_limit: marks_speedy_time_limit,
        max_marks: marks_speedy_max
      },
      complete_set: marks_complete_set,
      remaining_lives: marks_remaining_lives,
      actual_answer: marks_actual_answer,
      consistency_bonus: marks_consistency_bonus,
      remaining_time: marks_remaining_time,
      alone_box: marks_alone_box,
      minimum_steps: marks_minimum_steps,
      minimum_cards: marks_minimum_cards,
    }
  end

  def end_screen
    {
      star_thresholds:{
        two_star: star_threshold_2,
        three_star: star_threshold_3
      },
      display: {
        reports: {
          accuracy: display_report_accuracy,
          content: display_report_content,
        },
        remaining_lives: display_remaining_lives,
        speedy_answers: display_speedy_answer,
        perfect_sets: display_perfect_set,
        longest_streaks: display_longest_streak,
        accurate_answer: display_accurate_answer,
        errors: display_errors,
        remaining_time: display_remaining_time 
      }
    }
  end
end
