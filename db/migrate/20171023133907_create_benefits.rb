class CreateBenefits < ActiveRecord::Migration[5.1]
  def change
    create_table :benefits do |t|
      t.string :name
      t.string :slug
      t.string :explainer
      t.integer :sequence
      t.string :image_url

      t.timestamps
    end
    add_index :benefits, :slug, unique: true
  end
end
