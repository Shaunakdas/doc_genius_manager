class AddEnabledToStandard < ActiveRecord::Migration[5.1]
  def change
    add_column :standards, :enabled, :boolean
  end
end
