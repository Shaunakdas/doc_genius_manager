class AddCorrectAnswerTextToExternalQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :external_questions, :correct_answer_text, :string
  end
end
