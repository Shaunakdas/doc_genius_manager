class AddGameLevelToGameQuestion < ActiveRecord::Migration[5.1]
  def change
    add_reference :game_questions, :game_level, foreign_key: true
  end
end
