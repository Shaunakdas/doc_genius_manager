class Question < ApplicationRecord
  has_many :sub_questions, class_name: "Question", foreign_key: "parent_question_id"
  belongs_to :parent_question, class_name: "Question", optional: true
  belongs_to :marker_gap, optional: true
  enum position: [ :left, :right, :bottom ]
  include GameStructure
  def self.remove_question_fields params
    return params if params['question'].nil? || (params['question'].is_a? (String))
    return params.delete('question') if params['question'].is_a? ActionController::Parameters
  end

  def self.attribute_mapping
    {
      mode: "mode",
      setup: "setup",
      title: "title",
      question: "display",
      answer: "solution",
      tips: "tip",
      tip: "tip",
      type: "value_type",
      section_question: "title",
      steps: "steps",
      hint_content: "hint",
      solution: "solution",
      bubble: "title",
    }
  end

  def self.structure game
    GameStructure.parent_question_structure(game.slug)
  end
end
