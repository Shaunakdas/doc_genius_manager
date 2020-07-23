class AddAssetUrlToCharacterDialog < ActiveRecord::Migration[5.1]
  def change
    add_column :character_dialogs, :audio_url, :string
    add_column :character_dialogs, :image_url, :string
  end
end
