class AddGameLevelToBenifit < ActiveRecord::Migration[5.1]
  def change
    add_reference :benifits, :game_level, foreign_key: true
  end
end
