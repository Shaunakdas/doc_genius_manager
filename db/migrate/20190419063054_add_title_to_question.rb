class AddTitleToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :title, :string
  end
end
