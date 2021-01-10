class AddAssetsToOption < ActiveRecord::Migration[5.1]
  def change
    add_column :options, :image_url, :string
    add_column :options, :audio_url, :string
  end
end
