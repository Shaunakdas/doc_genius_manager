class AddPositionToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :position, :int
  end
end
