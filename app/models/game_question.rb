class GameQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :game_holder, optional: true
  has_many :sub_questions, class_name: "GameQuestion", foreign_key: "parent_question_id"
  belongs_to :parent_question, class_name: "GameQuestion", optional: true
  has_many :game_options, -> { order 'id asc' }
end
