class AddQuestionTypeToBenifits < ActiveRecord::Migration[5.1]
  def change
    add_reference :benifits, :question_type, foreign_key: true
  end
end
