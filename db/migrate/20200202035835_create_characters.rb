class CreateCharacters < ActiveRecord::Migration[5.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :characters, :slug, unique: true
  end
end
