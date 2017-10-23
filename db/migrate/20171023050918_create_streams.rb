class CreateStreams < ActiveRecord::Migration[5.1]
  def change
    create_table :streams do |t|
      t.string :name
      t.string :slug
      t.integer :sequence
      t.references :subject, foreign_key: true

      t.timestamps
    end
    add_index :streams, :slug, unique: true
  end
end
