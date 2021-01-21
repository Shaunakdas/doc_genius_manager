class AddEnabledToSubject < ActiveRecord::Migration[5.1]
  def change
    add_column :subjects, :enabled, :boolean
  end
end
