class CreateOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :options do |t|
      t.string :upper
      t.string :lower
      t.string :hint
      t.string :display
      t.string :value
      t.string :type
      t.string :after_attempt
      t.integer :sequence
      t.boolean :correct

      t.timestamps
    end
  end
end
