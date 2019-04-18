class CreateGameQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :game_questions do |t|
      t.integer :difficulty
      t.integer :time_alloted
      t.references :question, foreign_key: true
      t.references :game_holder, foreign_key: true
      t.references :parent_question

      t.timestamps
    end
  end
end
