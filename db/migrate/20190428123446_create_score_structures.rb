class CreateScoreStructures < ActiveRecord::Migration[5.1]
  def change
    create_table :score_structures do |t|
      t.references :game_holder, foreign_key: true
      t.integer :limiter_time_question
      t.integer :limiter_time_game
      t.integer :limiter_option
      t.integer :limiter_question
      t.integer :limiter_lives
      t.integer :marks_normal_attempt
      t.integer :marks_normal_time
      t.integer :marks_speedy_time_limit
      t.integer :marks_speedy_max
      t.integer :marks_complete_set
      t.integer :marks_remaining_lives
      t.integer :marks_actual_answer
      t.integer :marks_consistency_bonus
      t.integer :marks_remaining_time
      t.integer :star_threshold_2
      t.integer :star_threshold_3
      t.boolean :display_report_accuracy, default: false
      t.boolean :display_report_content, default: false
      t.boolean :display_remaining_lives, default: false
      t.boolean :display_speedy_answer, default: false
      t.boolean :display_perfect_set, default: false
      t.boolean :display_longest_streak, default: false
      t.boolean :display_accurate_answer, default: false
      t.boolean :display_errors, default: false
      t.boolean :display_remaining_time, default: false

      t.timestamps
    end
  end
end
