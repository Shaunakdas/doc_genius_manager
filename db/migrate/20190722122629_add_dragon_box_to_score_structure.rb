class AddDragonBoxToScoreStructure < ActiveRecord::Migration[5.1]
  def change
    add_column :score_structures, :marks_alone_box, :integer
    add_column :score_structures, :marks_minimum_steps, :integer
    add_column :score_structures, :marks_minimum_cards, :integer
  end
end
