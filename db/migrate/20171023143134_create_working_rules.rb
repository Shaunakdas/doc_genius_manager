class CreateWorkingRules < ActiveRecord::Migration[5.1]
  def change
    create_table :working_rules do |t|
      t.string :name
      t.string :slug
      t.integer :sequence
      t.string :question_text
      t.references :difficulty_level, foreign_key: true

      t.timestamps
    end
    add_index :working_rules, :slug, unique: true
  end
end
