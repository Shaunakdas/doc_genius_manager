class CreateAttemptScores < ActiveRecord::Migration[5.1]
  def change
    create_table :attempt_scores do |t|
      t.references :attempt_item, polymorphic: true
      t.boolean :displayed
      t.integer :time_spent
      t.boolean :passed
      t.integer :tap_count
      t.string :user_input
      t.integer :correct_count
      t.integer :star_count
      t.integer :normal_marks
      t.integer :speedy_marks
      t.integer :complete_set_marks
      t.integer :actual_answer_marks
      t.integer :consistency_marks
      t.integer :remaining_time_marks
      t.integer :remaining_lives_marks

      t.timestamps
    end
  end
end
