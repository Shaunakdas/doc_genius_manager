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
      hint: "hint",
      bubble: "title",
    }
  end

  def self.structure game
    case game.slug
    when "agility"
      GameStructure.agility_structure
    when "conversion"
      GameStructure.conversion_structure
    when "diction"
      GameStructure.diction_structure
    when "discounting"
      GameStructure.discounting_structure
    when "division"
      GameStructure.division_structure
    when "estimation"
      GameStructure.estimation_structure
    when "inversion"
      GameStructure.inversion_structure
    when "percentages"
      GameStructure.percentages_structure
    when "proportion"
      GameStructure.proportion_structure
    when "purchasing"
      GameStructure.purchasing_structure
    when "refinement"
      GameStructure.refinement_structure
    when "tipping"
      GameStructure.tipping_structure
    else
      GameStructure.agility_structure
    end
  end
end
