class CreateGameHolderSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :game_holder_sessions do |t|
      t.references :game_holder, foreign_key: true
      t.references :user, foreign_key: true
      t.string :url_code
      t.string :join_code
      t.date :creation_date
      t.date :start_date
      t.date :completion_date
      t.integer :completion_status
      t.integer :attempt_type
      t.string :title

      t.timestamps
    end
  end
end
