class AddAssetUrlToOption < ActiveRecord::Migration[5.1]
  def change
    add_column :options, :prefix_url, :string
  end
end
