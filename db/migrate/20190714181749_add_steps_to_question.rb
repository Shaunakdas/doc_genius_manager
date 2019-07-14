class AddStepsToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :steps, :int
    add_column :questions, :setup, :string
  end
end
