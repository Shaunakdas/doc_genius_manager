class CreateGameLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :game_levels do |t|
      t.string :name
      t.string :slug
      t.references :game_holder, foreign_key: true
      t.integer :practice_mode
      t.integer :nature_effect
      t.integer :sequence
      t.references :intro_discussion, foreign_key: { to_table: :character_discussions }
      t.references :success_discussion, foreign_key: { to_table: :character_discussions }
      t.references :fail_discussion, foreign_key: { to_table: :character_discussions }
      t.integer :standard_sequence

      t.timestamps
    end
    add_index :game_levels, :slug, unique: true
  end
end
