class CreateGameSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :game_sessions do |t|
      t.datetime :start
      t.datetime :finish
      t.references :game_holder, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
