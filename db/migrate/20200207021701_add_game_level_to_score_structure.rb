class AddGameLevelToScoreStructure < ActiveRecord::Migration[5.1]
  def change
    add_reference :score_structures, :game_level, foreign_key: true
  end
end
