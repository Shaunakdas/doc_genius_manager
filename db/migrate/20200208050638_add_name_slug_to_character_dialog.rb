class AddNameSlugToCharacterDialog < ActiveRecord::Migration[5.1]
  def change
    add_column :character_dialogs, :name, :string
    add_column :character_dialogs, :slug, :string
  end
end
