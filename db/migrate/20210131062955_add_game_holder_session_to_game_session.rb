class AddGameHolderSessionToGameSession < ActiveRecord::Migration[5.1]
  def change
    add_reference :game_sessions, :game_holder_session, foreign_key: true
  end
end
