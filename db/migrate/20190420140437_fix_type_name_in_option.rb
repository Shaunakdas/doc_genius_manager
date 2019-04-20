class FixTypeNameInOption < ActiveRecord::Migration[5.1]
  def change
    rename_column :options, :type, :value_type
  end
end
