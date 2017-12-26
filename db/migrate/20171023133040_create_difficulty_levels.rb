class CreateDifficultyLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :difficulty_levels do |t|
      t.string :name
      t.string :slug
      t.integer :sequence
      t.integer :value

      t.timestamps
    end
    add_index :difficulty_levels, :slug, unique: true
  end
end
