class CreateGameHolders < ActiveRecord::Migration[5.1]
  def change
    create_table :game_holders do |t|
      t.string :name
      t.string :slug
      t.integer :sequence
      t.references :game, polymorphic: true
      t.string :image_url
      t.references :question_type, foreign_key: true

      t.timestamps
    end
    add_index :game_holders, :slug, unique: true
  end
end
