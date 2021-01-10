class ChangeQuestionColumnInExternalQuestion < ActiveRecord::Migration[5.1]
  def change
    rename_column :external_questions, :question, :display
    rename_column :external_questions, :options, :joined_options
  end
end
