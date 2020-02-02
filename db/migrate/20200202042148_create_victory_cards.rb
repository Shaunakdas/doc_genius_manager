class CreateVictoryCards < ActiveRecord::Migration[5.1]
  def change
    create_table :victory_cards do |t|
      t.string :name
      t.string :slug
      t.references :acad_entity, polymorphic: true
      t.string :title
      t.string :description
      t.integer :max_count
      t.integer :sequence

      t.timestamps
    end
    add_index :victory_cards, :slug, unique: true
  end
end
