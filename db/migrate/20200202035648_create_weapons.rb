class CreateWeapons < ActiveRecord::Migration[5.1]
  def change
    create_table :weapons do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :weapons, :slug, unique: true
  end
end
