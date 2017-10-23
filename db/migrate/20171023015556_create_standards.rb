class CreateStandards < ActiveRecord::Migration[5.1]
  def change
    create_table :standards do |t|
      t.string :name
      t.string :slug
      t.integer :sequence

      t.timestamps
    end
    add_index :standards, :slug, unique: true
  end
end
