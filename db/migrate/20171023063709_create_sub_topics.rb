class CreateSubTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_topics do |t|
      t.string :name
      t.string :slug
      t.integer :sequence
      t.references :topic, foreign_key: true

      t.timestamps
    end
    add_index :sub_topics, :slug, unique: true
  end
end
