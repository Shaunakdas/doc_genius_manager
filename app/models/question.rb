class Question < ApplicationRecord
  has_many :sub_questions, class_name: "Question", foreign_key: "parent_question_id"
  belongs_to :parent_question, class_name: "Question", optional: true
  belongs_to :marker_gap, optional: true
  enum position: [ :left, :right, :bottom ]
end
