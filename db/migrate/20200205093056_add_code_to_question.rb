class AddCodeToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :code, :string
    add_index :questions, :code, unique: true
  end
end
