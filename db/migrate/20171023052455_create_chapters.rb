class CreateChapters < ActiveRecord::Migration[5.1]
  def change
    create_table :chapters do |t|
      t.string :name
      t.string :slug
      t.integer :sequence_stream
      t.integer :sequence_standard
      t.references :standard, foreign_key: true
      t.references :stream, foreign_key: true

      t.timestamps
    end
    add_index :chapters, :slug, unique: true
  end
end
