class AddQuestionTypeToExternalQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :external_questions, :question_type, :string
  end
end
