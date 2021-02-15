class CreateGameHolderActions < ActiveRecord::Migration[5.1]
  def change
    create_table :game_holder_actions do |t|
      t.references :game_holder, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :action_type

      t.timestamps
    end
  end
end