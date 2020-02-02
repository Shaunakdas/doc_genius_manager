class CreateGameLevelVictoryCards < ActiveRecord::Migration[5.1]
  def change
    create_table :game_level_victory_cards do |t|
      t.references :game_level, foreign_key: true
      t.references :victory_card, foreign_key: true
      t.integer :current_count

      t.timestamps
    end
  end
end
