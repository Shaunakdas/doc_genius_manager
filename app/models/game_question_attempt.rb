class GameQuestionAttempt < ApplicationRecord
  belongs_to :game_question
  belongs_to :game_session
end
