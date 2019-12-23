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

  def self.create_content(params, game_holder)
    question_params = {}
    params = Question.remove_question_fields(params)
    params = Question.create_validations(params, game_holder)
    Question.attribute_mapping.each do | game_question_key, question_key  |
      question_params[question_key] = params[game_question_key] if !params[game_question_key].nil?
    end
    question = Question.new(question_params)
    return question if question.save!
    return nil
  end

  def self.create_validations(params, game_holder)
    required_fields = GameStructure.generic_question_required_fields(game_holder.game.slug)
    if required_fields.all? {|k| params.has_key? k}
      return params.permit(GameStructure.generic_question_fields(game_holder.game.slug))
    else
      missing_fields = []
      required_fields.each do |field|
        missing_fields << field if !params.has_key?(field)
      end
      raise ArgumentError.new("Some parameters are missing: #{missing_fields.join(', ')}")
    end
  end

  def self.structure game
    GameStructure.parent_question_structure(game.slug)
  end
end
