class GameOption < ApplicationRecord
  belongs_to :option
  belongs_to :game_question
end
