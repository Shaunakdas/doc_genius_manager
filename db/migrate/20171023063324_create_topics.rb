class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :name
      t.string :slug
      t.integer :sequence
      t.references :chapter, foreign_key: true

      t.timestamps
    end
    add_index :topics, :slug, unique: true
  end
end
