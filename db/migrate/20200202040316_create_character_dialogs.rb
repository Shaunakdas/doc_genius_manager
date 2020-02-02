class CreateCharacterDialogs < ActiveRecord::Migration[5.1]
  def change
    create_table :character_dialogs do |t|
      t.references :character_discussion, foreign_key: true
      t.references :character, foreign_key: true
      t.references :left_weapon, foreign_key: { to_table: :weapons }
      t.string :left_weapon_colour
      t.references :right_weapon, foreign_key: { to_table: :weapons }
      t.string :right_weapon_colour
      t.integer :count
      t.integer :position
      t.integer :animation
      t.integer :repeat_mode
      t.integer :sequence

      t.timestamps
    end
  end
end
