class GameLevel < ApplicationRecord
  belongs_to :game_holder
  belongs_to :intro_discussion
  belongs_to :success_discussion
  belongs_to :fail_discussion
end
