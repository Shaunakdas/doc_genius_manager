class Question < ApplicationRecord
  has_many :sub_questions, class_name: "Question", foreign_key: "parent_question_id"
  belongs_to :parent_question, class_name: "Question", optional: true
  belongs_to :marker_gap, optional: true
  enum position: [ :left, :right, :bottom ]
  include GameStructure
  def self.remove_question_fields params
    return params if params['question'].nil? || (params['question'].is_a? (String))
    params.delete('question') if params['question'].is_a? ActionController::Parameters
    return params
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

  def self.create_content(params, game_holder, is_parent)
    question_params = {}
    params = Question.remove_question_fields(params)
    params = Question.create_validations(params, game_holder, is_parent)
    Question.attribute_mapping.each do | game_question_key, question_key  |
      question_params[question_key] = params[game_question_key] if !params[game_question_key].nil?
    end
    question = Question.new(question_params)
    return question if question.save!
    return nil
  end

  def self.create_validations(params, game_holder, is_parent)
    required_fields = GameStructure.generic_question_required_fields(game_holder, is_parent)
    return params if required_fields.length == 0 
    if required_fields.all? {|k| ((params.has_key? k) && (!params[k].nil?) && (params[k] != ""))}
      return params.permit(GameStructure.generic_question_fields(game_holder, is_parent))
    else
      missing_fields = []
      required_fields.each do |k|
        missing_fields << k if !((params.has_key? k) && (!params[k].nil?) && (params[k] != ""))
      end
      raise ArgumentError.new("Question couldn't be created due to missing parameters: #{missing_fields.join(', ')}")
    end
  end

  def self.structure game
    GameStructure.parent_question_structure(game.slug)
  end

  def self.search_code(search)
    where('code LIKE :search', search: "#{search}")
  end

  def self.parse_hint_structure hint
    return nil if hint.nil?
    # return hint if !(hint.include?('<br/>') || hint.include?('<p/>'))
    hint = hint.gsub("\table", "\\table")
    pages = hint.split('<p/>')
    page_json = []
    pages.each do |page|
      page_json << { lines: page.split('<br/>')}
    end
    return { pages: page_json}
  end

  def s3_slug
    return nil if code.nil?
    "#{code.split("-")[-1]}_q"
  end

  def has_hint
    !hint.nil? || !solution.nil?
  end
end
