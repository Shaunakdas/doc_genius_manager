class CreateAcadProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :acad_profiles do |t|
      t.references :acad_entity, polymorphic: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
