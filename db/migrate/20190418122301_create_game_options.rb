class CreateGameOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :game_options do |t|
      t.references :option, foreign_key: true
      t.references :game_question, foreign_key: true

      t.timestamps
    end
  end
end
