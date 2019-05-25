class AddDisplayIndexToOption < ActiveRecord::Migration[5.1]
  def change
    add_column :options, :display_index, :integer
    add_column :options, :sub_title, :string
  end
end
