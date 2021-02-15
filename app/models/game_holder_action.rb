class GameHolderAction < ApplicationRecord
  belongs_to :user
  belongs_to :game_holder
  enum action_type: [ :like, :save_action]
end
