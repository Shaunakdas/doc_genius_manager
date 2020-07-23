class AddPrefixUrlToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :prefix_url, :string
  end
end
