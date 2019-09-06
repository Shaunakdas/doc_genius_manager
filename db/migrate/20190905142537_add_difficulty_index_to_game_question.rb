class AddDifficultyIndexToGameQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :game_questions, :difficulty_index, :integer, default: 0
  end
end
