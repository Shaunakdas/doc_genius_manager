class AddAcadEntityToGameHolder < ActiveRecord::Migration[5.1]
  def change
    add_reference :game_holders, :acad_entity, polymorphic: true
  end
end
