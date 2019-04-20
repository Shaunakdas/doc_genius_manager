class AddEnabledToTopic < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :enabled, :boolean, default: false
  end
end
