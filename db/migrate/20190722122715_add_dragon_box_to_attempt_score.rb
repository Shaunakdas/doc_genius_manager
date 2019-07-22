class AddDragonBoxToAttemptScore < ActiveRecord::Migration[5.1]
  def change
    add_column :attempt_scores, :alone_box_marks, :integer
    add_column :attempt_scores, :minimum_steps_marks, :integer
    add_column :attempt_scores, :minimum_cards_marks, :integer
  end
end
