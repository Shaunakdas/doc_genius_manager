class CreateGameOptionAttempts < ActiveRecord::Migration[5.1]
  def change
    create_table :game_option_attempts do |t|
      t.boolean :is_attempted
      t.boolean :is_attempted_correctly
      t.string :user_input
      t.integer :time_attempt
      t.references :game_option, foreign_key: true
      t.references :game_question_attempt, foreign_key: true

      t.timestamps
    end
  end
end
