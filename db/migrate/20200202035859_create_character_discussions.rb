class CreateCharacterDiscussions < ActiveRecord::Migration[5.1]
  def change
    create_table :character_discussions do |t|
      t.string :name
      t.string :slug
      t.string :description

      t.timestamps
    end
    add_index :character_discussions, :slug, unique: true
  end
end
