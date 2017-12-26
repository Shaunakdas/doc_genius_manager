class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :subjects, :slug, unique: true
  end
end
