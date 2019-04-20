class AddEnabledToChapter < ActiveRecord::Migration[5.1]
  def change
    add_column :chapters, :enabled, :boolean, default: false
  end
end
