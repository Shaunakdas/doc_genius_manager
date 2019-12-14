class Question < ApplicationRecord
  has_many :sub_questions, class_name: "Question", foreign_key: "parent_question_id"
  belongs_to :parent_question, class_name: "Question", optional: true
  belongs_to :marker_gap, optional: true
  enum position: [ :left, :right, :bottom ]
  include GameStructure

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
