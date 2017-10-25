class AddBirthSexToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sex, :integer
    add_column :users, :birth, :date
    add_column :users, :registration_method, :integer
  end
end
