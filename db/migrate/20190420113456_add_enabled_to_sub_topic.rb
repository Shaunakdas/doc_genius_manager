class AddEnabledToSubTopic < ActiveRecord::Migration[5.1]
  def change
    add_column :sub_topics, :enabled, :boolean, default: false
  end
end
