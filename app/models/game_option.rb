class GameOption < ApplicationRecord
  belongs_to :option, optional: true
  belongs_to :game_question, optional: true
  has_many :game_option_attempts
  has_many :sub_options, class_name: "GameOption", foreign_key: "parent_option_id"
  belongs_to :parent_option, class_name: "GameOption", optional: true
  belongs_to :option_type, optional: true
  enum position: [ :numerator, :denominator ]

  def create_attempt_data option_obj, game_question_attempt
    op_attempt = game_option_attempts.create!(time_attempt: Time.now, game_option: self, game_question_attempt: game_question_attempt)
    op_attempt.set_attempt_score(option_obj) if option_obj
  end
end
