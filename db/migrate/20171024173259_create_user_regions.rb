class CreateUserRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_regions do |t|
      t.date :registration_date
      t.references :user, foreign_key: true
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
