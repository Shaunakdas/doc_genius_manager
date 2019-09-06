class AddDifficultyIndexToGameSession < ActiveRecord::Migration[5.1]
  def change
    add_column :game_sessions, :end_difficulty_index, :integer, default: 0
    add_column :game_sessions, :next_difficulty_index, :integer, default: 0
  end
end
