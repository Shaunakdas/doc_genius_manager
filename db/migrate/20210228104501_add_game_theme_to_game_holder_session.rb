class AddGameThemeToGameHolderSession < ActiveRecord::Migration[5.1]
  def change
    add_reference :game_holder_sessions, :game_theme, foreign_key: true
  end
end
