class CreateUserGameThemes < ActiveRecord::Migration[5.1]
  def change
    create_table :user_game_themes do |t|
      t.references :game_theme, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
