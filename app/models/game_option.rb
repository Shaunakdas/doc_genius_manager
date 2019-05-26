class GameOption < ApplicationRecord
  belongs_to :option
  belongs_to :game_question
  has_many :game_option_attempts

  def create_attempt_data option_obj, game_question_attempt
    op_attempt = game_option_attempts.create!(time_attempt: Time.now, game_option: self, game_question_attempt: game_question_attempt)
    op_attempt.set_attempt_score(option_obj) if option_obj
  end
end
