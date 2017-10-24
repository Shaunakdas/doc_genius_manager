class CreateRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :regions do |t|
      t.string :slug
      t.string :name
      t.string :region_type
      t.references :parent_region, index: true

      t.timestamps
    end
    add_index :regions, :slug, unique: true
  end
end
