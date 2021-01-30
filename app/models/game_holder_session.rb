class GameHolderSession < ApplicationRecord
  belongs_to :game_holder
  belongs_to :user
end
