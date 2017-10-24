class CreateSessionScores < ActiveRecord::Migration[5.1]
  def change
    create_table :session_scores do |t|
      t.decimal :value
      t.time :time_taken
      t.integer :correct_count
      t.integer :incorrect_count
      t.boolean :seen
      t.boolean :passed
      t.boolean :failed
      t.references :game_session, foreign_key: true

      t.timestamps
    end
  end
end
