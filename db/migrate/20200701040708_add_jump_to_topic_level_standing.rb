class AddJumpToTopicLevelStanding < ActiveRecord::Migration[5.1]
  def change
    add_column :topic_level_standings, :jump, :boolean
  end
end
