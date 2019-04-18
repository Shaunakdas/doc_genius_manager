class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :display
      t.string :hint
      t.string :tip
      t.string :solution
      t.string :mode
      t.references :parent_question

      t.timestamps
    end
  end
end
