class CreateRankNames < ActiveRecord::Migration[5.1]
  def change
    create_table :rank_names do |t|
      t.string :slug
      t.integer :sequence
      t.string :display_text
      t.string :explainer

      t.timestamps
    end
    add_index :rank_names, :slug, unique: true
  end
end
