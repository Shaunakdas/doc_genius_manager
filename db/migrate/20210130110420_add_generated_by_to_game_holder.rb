class AddGeneratedByToGameHolder < ActiveRecord::Migration[5.1]
  def change
    add_reference :game_holders, :generated_by, foreign_key: {to_table: :users}
  end
end
