class GameLevelVictoryCard < ApplicationRecord
  belongs_to :game_level
  belongs_to :victory_card
end
