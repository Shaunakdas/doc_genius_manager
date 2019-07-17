class CreateHintContents < ActiveRecord::Migration[5.1]
  def change
    create_table :hint_contents do |t|
      t.string :display
      t.integer :position
      t.references :hint, foreign_key: true

      t.timestamps
    end
  end
end
