class GameSession < ApplicationRecord
  belongs_to :game_holder
  belongs_to :user
  validates_presence_of :start
end
