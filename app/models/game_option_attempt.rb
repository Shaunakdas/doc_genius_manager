class GameOptionAttempt < ApplicationRecord
  belongs_to :game_option
  belongs_to :game_question_attempt
end
