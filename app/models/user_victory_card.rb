class UserVictoryCard < ApplicationRecord
  belongs_to :user
  belongs_to :victory_card
end
