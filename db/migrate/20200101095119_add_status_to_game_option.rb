class AddStatusToGameOption < ActiveRecord::Migration[5.1]
  def change
    add_column :game_options, :delete_status, :integer, default: 0
  end
end
