class AddEnabledToGameLevel < ActiveRecord::Migration[5.1]
  def change
    add_column :game_levels, :enabled, :boolean, default: false
  end
end
