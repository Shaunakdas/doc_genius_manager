class TopicLevelStanding < ApplicationRecord
  belongs_to :topic
  belongs_to :game_level
  belongs_to :user
end
