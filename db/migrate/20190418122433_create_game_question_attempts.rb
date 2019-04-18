class CreateGameQuestionAttempts < ActiveRecord::Migration[5.1]
  def change
    create_table :game_question_attempts do |t|
      t.integer :time_attempt
      t.boolean :passed
      t.boolean :attempted
      t.references :game_question, foreign_key: true
      t.references :game_session, foreign_key: true

      t.timestamps
    end
  end
end
