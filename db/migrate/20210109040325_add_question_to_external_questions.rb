class AddQuestionToExternalQuestions < ActiveRecord::Migration[5.1]
  def change
    add_reference :external_questions, :question, foreign_key: true
  end
end
