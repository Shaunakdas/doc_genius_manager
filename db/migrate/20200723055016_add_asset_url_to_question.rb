class AddAssetUrlToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :audio_url, :string
  end
end
