class AddStatusToGameQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :game_questions, :delete_status, :integer, default: 0
    add_column :game_questions, :approval_status, :integer, default: 0
  end
end
