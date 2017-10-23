class CreateQuestionTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :question_types do |t|
      t.string :name
      t.string :slug
      t.integer :sequence
      t.string :image_url
      t.references :sub_topic, foreign_key: true

      t.timestamps
    end
    add_index :question_types, :slug, unique: true
  end
end
