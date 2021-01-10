class AddAssetsToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :image_url, :string
    add_column :questions, :time, :integer
  end
end
