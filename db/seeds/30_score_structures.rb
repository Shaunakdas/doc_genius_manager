def add_game_holder_score_structure

  GameHolder.all.each do |game_holder|
    if game_holder.score_structure.nil? && game_holder.game_type == "PracticeType"
      case game_holder.game.slug
      when "agility"
        add_agility_score_structure(game_holder)
      when "conversion"
        add_conversion_score_structure(game_holder)
      when "diction"
        add_diction_score_structure(game_holder)
      when "discounting"
        add_discounting_score_structure(game_holder)
      when "division"
        add_division_score_structure(game_holder)
      when "estimation"
        add_estimation_score_structure(game_holder)
      when "inversion"
        add_inversion_score_structure(game_holder)
      when "percentages"
        add_percentages_score_structure(game_holder)
      when "proportion"
        add_proportion_score_structure(game_holder)
      when "purchasing"
        add_purchasing_score_structure(game_holder)
      when "refinement"
        add_refinement_score_structure(game_holder)
      when "tipping"
        add_tipping_score_structure(game_holder)
      else
        puts "Found a new type of practice_type game #{game_holder.to_json}"
      end
    end
  end
end

def add_agility_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: 10,
    limiter_time_game: nil,
    limiter_option: nil,
    limiter_question: nil,
    limiter_lives: 3,
    marks_normal_attempt: 450,
    marks_normal_time: nil,
    marks_speedy_time_limit: 5,
    marks_speedy_max: 40,
    marks_complete_set: nil,
    marks_remaining_lives: 1111,
    marks_actual_answer: nil,
    marks_consistency_bonus: nil,
    marks_remaining_time: nil,
    star_threshold_2: 7500,
    star_threshold_3: 8500,
    display_report_accuracy: true,
    display_report_content: true,
    display_remaining_lives: true,
    display_speedy_answer: true,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: false
  )
  puts "Agility GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end

def add_conversion_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: nil,
    limiter_time_game: 80,
    limiter_option: 15,
    limiter_question: nil,
    limiter_lives: nil,
    marks_normal_attempt: 450,
    marks_normal_time: nil,
    marks_speedy_time_limit: 5,
    marks_speedy_max: 40,
    marks_complete_set: 1100,
    marks_remaining_lives: nil,
    marks_actual_answer: nil,
    marks_consistency_bonus: nil,
    marks_remaining_time: 120,
    star_threshold_2: 11000,
    star_threshold_3: 13000,
    display_report_accuracy: true,
    display_report_content: false,
    display_remaining_lives: false,
    display_speedy_answer: false,
    display_perfect_set: true,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: true
  )
  puts "Conversion GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end


def add_diction_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: nil,
    limiter_time_game: 60,
    limiter_option: nil,
    limiter_question: 7,
    limiter_lives: nil,
    marks_normal_attempt: 1200,
    marks_normal_time: nil,
    marks_speedy_time_limit: nil,
    marks_speedy_max: nil,
    marks_complete_set: nil,
    marks_remaining_lives: nil,
    marks_actual_answer: nil,
    marks_consistency_bonus: 400,
    marks_remaining_time: 120,
    star_threshold_2: 9000,
    star_threshold_3: 13000,
    display_report_accuracy: true,
    display_report_content: true,
    display_remaining_lives: false,
    display_speedy_answer: false,
    display_perfect_set: false,
    display_longest_streak: true,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: true
  )
  puts "Diction GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end


def add_discounting_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: 14,
    limiter_time_game: nil,
    limiter_option: nil,
    limiter_question: 5,
    limiter_lives: 4,
    marks_normal_attempt: 480,
    marks_normal_time: nil,
    marks_speedy_time_limit: 7,
    marks_speedy_max: 140,
    marks_complete_set: nil,
    marks_remaining_lives: 800,
    marks_actual_answer: nil,
    marks_consistency_bonus: nil,
    marks_remaining_time: nil,
    star_threshold_2: 9000,
    star_threshold_3: 13000,
    display_report_accuracy: true,
    display_report_content: false,
    display_remaining_lives: true,
    display_speedy_answer: true,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: false
  )
  puts "Discounting GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end


def add_division_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: nil,
    limiter_time_game: nil,
    limiter_option: nil,
    limiter_question: 7,
    limiter_lives: 3,
    marks_normal_attempt: 960,
    marks_normal_time: nil,
    marks_speedy_time_limit: 5,
    marks_speedy_max: 120,
    marks_complete_set: nil,
    marks_remaining_lives: 1250,
    marks_actual_answer: nil,
    marks_consistency_bonus: nil,
    marks_remaining_time: nil,
    star_threshold_2: 9000,
    star_threshold_3: 11000,
    display_report_accuracy: true,
    display_report_content: false,
    display_remaining_lives: true,
    display_speedy_answer: true,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: false
  )
  puts "Division GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end


def add_estimation_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: nil,
    limiter_time_game: 65,
    limiter_option: nil,
    limiter_question: 6,
    limiter_lives: nil,
    marks_normal_attempt: 1200,
    marks_normal_time: nil,
    marks_speedy_time_limit: nil,
    marks_speedy_max: nil,
    marks_complete_set: nil,
    marks_remaining_lives: nil,
    marks_actual_answer: 30,
    marks_consistency_bonus: nil,
    marks_remaining_time: 130,
    star_threshold_2: 8000,
    star_threshold_3: 9500,
    display_report_accuracy: false,
    display_report_content: false,
    display_remaining_lives: false,
    display_speedy_answer: false,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: true,
    display_errors: false,
    display_remaining_time: true
  )
  puts "Estimation GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end



def add_inversion_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: nil,
    limiter_time_game: nil,
    limiter_option: nil,
    limiter_question: 30,
    limiter_lives: nil,
    marks_normal_attempt: 450,
    marks_normal_time: nil,
    marks_speedy_time_limit: nil,
    marks_speedy_max: nil,
    marks_complete_set: nil,
    marks_remaining_lives: nil,
    marks_actual_answer: nil,
    marks_consistency_bonus: 3500,
    marks_remaining_time: nil,
    star_threshold_2: 8000,
    star_threshold_3: 10000,
    display_report_accuracy: true,
    display_report_content: true,
    display_remaining_lives: false,
    display_speedy_answer: false,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: true,
    display_remaining_time: false
  )
  puts "Inversion GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end



def add_percentages_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: 25,
    limiter_time_game: nil,
    limiter_option: nil,
    limiter_question: 12,
    limiter_lives: 3,
    marks_normal_attempt: 550,
    marks_normal_time: nil,
    marks_speedy_time_limit: 5,
    marks_speedy_max: 100,
    marks_complete_set: nil,
    marks_remaining_lives: 1300,
    marks_actual_answer: nil,
    marks_consistency_bonus: nil,
    marks_remaining_time: nil,
    star_threshold_2: 9000,
    star_threshold_3: 11000,
    display_report_accuracy: true,
    display_report_content: false,
    display_remaining_lives: true,
    display_speedy_answer: true,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: false
  )
  puts "Percentages GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end



def add_proportion_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: nil,
    limiter_time_game: 110,
    limiter_option: nil,
    limiter_question: 6,
    limiter_lives: nil,
    marks_normal_attempt: 1300,
    marks_normal_time: nil,
    marks_speedy_time_limit: nil,
    marks_speedy_max: nil,
    marks_complete_set: nil,
    marks_remaining_lives: nil,
    marks_actual_answer: nil,
    marks_consistency_bonus: nil,
    marks_remaining_time: 130,
    star_threshold_2: 10000,
    star_threshold_3: 13000,
    display_report_accuracy: false,
    display_report_content: false,
    display_remaining_lives: false,
    display_speedy_answer: false,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: true
  )
  puts "Proportion GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end



def add_purchasing_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: nil,
    limiter_time_game: 68,
    limiter_option: nil,
    limiter_question: 9,
    limiter_lives: nil,
    marks_normal_attempt: 1000,
    marks_normal_time: nil,
    marks_speedy_time_limit: nil,
    marks_speedy_max: nil,
    marks_complete_set: nil,
    marks_remaining_lives: nil,
    marks_actual_answer: nil,
    marks_consistency_bonus: 480,
    marks_remaining_time: 130,
    star_threshold_2: 11000,
    star_threshold_3: 12500,
    display_report_accuracy: true,
    display_report_content: false,
    display_remaining_lives: false,
    display_speedy_answer: false,
    display_perfect_set: false,
    display_longest_streak: true,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: true
  )
  puts "Purchasing GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end


def add_refinement_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: 23,
    limiter_time_game: nil,
    limiter_option: nil,
    limiter_question: nil,
    limiter_lives: 2,
    marks_normal_attempt: 2750,
    marks_normal_time: nil,
    marks_speedy_time_limit: 4,
    marks_speedy_max: 90,
    marks_complete_set: nil,
    marks_remaining_lives: nil,
    marks_actual_answer: nil,
    marks_consistency_bonus: nil,
    marks_remaining_time: nil,
    star_threshold_2: 8500,
    star_threshold_3: 10000,
    display_report_accuracy: true,
    display_report_content: false,
    display_remaining_lives: false,
    display_speedy_answer: true,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: false
  )
  puts "Refinement GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end


def add_tipping_score_structure(game_holder)
  score_structure = ScoreStructure.create!(
    game_holder: game_holder,
    limiter_time_question: nil,
    limiter_time_game: 45,
    limiter_option: nil,
    limiter_question: nil,
    limiter_lives: 3,
    marks_normal_attempt: nil,
    marks_normal_time: 111,
    marks_speedy_time_limit: 3,
    marks_speedy_max: 120,
    marks_complete_set: nil,
    marks_remaining_lives: 1111,
    marks_actual_answer: nil,
    marks_consistency_bonus: nil,
    marks_remaining_time: nil,
    star_threshold_2: 6000,
    star_threshold_3: 7500,
    display_report_accuracy: true,
    display_report_content: false,
    display_remaining_lives: true,
    display_speedy_answer: true,
    display_perfect_set: false,
    display_longest_streak: false,
    display_accurate_answer: false,
    display_errors: false,
    display_remaining_time: false
  )
  puts "Tipping GameHolder score structure added #{score_structure.to_json}" if score_structure
  puts "Error in adding score structure for game_holder: #{game_holder.to_json}" if !score_structure
  return score_structure
end


# add_game_holder_score_structure

def set_game_holder_content
  GameHolder.all.each do |game_holder|
    if game_holder.score_structure && game_holder.game_type == "PracticeType"
      if game_holder.game.slug == "diction"
        game_holder.score_structure.update_attributes!(display_report_content: true)
      elsif game_holder.game.slug == "division"
        game_holder.score_structure.update_attributes!(display_report_content: true)
      elsif game_holder.game.slug == "refinement"
        game_holder.score_structure.update_attributes!(display_report_content: true)
      elsif game_holder.game.slug == "percentages"
        game_holder.score_structure.update_attributes!(display_report_content: true)
      end
    end
  end
end

# set_game_holder_content