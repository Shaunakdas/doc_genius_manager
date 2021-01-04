class CreateExternalQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :external_questions do |t|
      t.string :question
      t.integer :time
      t.string :image_url
      t.string :s3_image_url
      t.string :audio_url
      t.string :s3_audio_url
      t.string :options
      t.integer :correct_option
      t.string :answer_url
      t.string :s3_answer_url
      t.references :external_quiz_source, foreign_key: true

      t.timestamps
    end
  end
end
