class AddTitleToGameLevel < ActiveRecord::Migration[5.1]
  def change
    add_column :game_levels, :title, :string
    add_column :game_levels, :description, :string
  end
end
