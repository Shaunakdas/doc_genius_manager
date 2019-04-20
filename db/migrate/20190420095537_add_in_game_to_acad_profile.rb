class AddInGameToAcadProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :acad_profiles, :in_game, :boolean, default: false
  end
end
