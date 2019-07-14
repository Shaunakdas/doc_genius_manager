class AddParentOptionToGameOption < ActiveRecord::Migration[5.1]
  def change
    add_reference :game_options, :parent_option
    add_column :game_options, :position, :int
    add_reference :game_options, :option_type, foreign_key: true
  end
end
