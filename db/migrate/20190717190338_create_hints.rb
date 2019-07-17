class CreateHints < ActiveRecord::Migration[5.1]
  def change
    create_table :hints do |t|
      t.string :value_type
      t.references :acad_entity, polymorphic: true

      t.timestamps
    end
  end
end
