class AddArmoryToCharacterDialog < ActiveRecord::Migration[5.1]
  def change
    add_column :character_dialogs, :helmet_name, :string
    add_column :character_dialogs, :helmet_colour, :string
    add_column :character_dialogs, :armor_name, :string
    add_column :character_dialogs, :armor_colour, :string
    add_column :character_dialogs, :cape_name, :string
    add_column :character_dialogs, :cape_colour, :string
    add_column :character_dialogs, :pants_name, :string
    add_column :character_dialogs, :pants_colour, :string
    add_column :character_dialogs, :gloves_name, :string
    add_column :character_dialogs, :gloves_colour, :string
    add_column :character_dialogs, :boots_name, :string
    add_column :character_dialogs, :boots_colour, :string
  end
end
