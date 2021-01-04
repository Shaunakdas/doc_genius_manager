class CreateExternalQuizSources < ActiveRecord::Migration[5.1]
  def change
    create_table :external_quiz_sources do |t|
      t.string :title
      t.string :quiz_type
      t.string :grade
      t.integer :accuracy
      t.integer :plays
      t.string :subject
      t.string :image_url
      t.string :s3_image_url
      t.string :source_url

      t.timestamps
    end
  end
end
