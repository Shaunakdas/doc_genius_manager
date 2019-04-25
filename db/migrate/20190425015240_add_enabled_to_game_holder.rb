class AddEnabledToGameHolder < ActiveRecord::Migration[5.1]
  def change
    add_column :game_holders, :enabled, :boolean, default: false
  end
end
