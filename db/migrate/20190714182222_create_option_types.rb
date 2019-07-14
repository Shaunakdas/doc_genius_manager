class CreateOptionTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :option_types do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
