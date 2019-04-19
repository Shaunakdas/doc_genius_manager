class AddTitleToOption < ActiveRecord::Migration[5.1]
  def change
    add_column :options, :title, :string
  end
end
