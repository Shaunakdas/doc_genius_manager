class AddUniqueMobileNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :mobile_number, unique: true
  end
end
