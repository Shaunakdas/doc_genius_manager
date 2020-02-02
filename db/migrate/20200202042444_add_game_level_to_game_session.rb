class AddGameLevelToGameSession < ActiveRecord::Migration[5.1]
  def change
    add_reference :game_sessions, :game_level, foreign_key: true
  end
end
