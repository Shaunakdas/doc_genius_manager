class CreateGameThemes < ActiveRecord::Migration[5.1]
  def change
    create_table :game_themes do |t|
      t.string :title
      t.json :payload

      t.timestamps
    end
  end
end
