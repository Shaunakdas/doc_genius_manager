class GameQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :game_holder, optional: true
  has_many :sub_questions, -> { order 'id asc' }, class_name: "GameQuestion", foreign_key: "parent_question_id"
  belongs_to :parent_question, class_name: "GameQuestion", optional: true
  has_many :game_options, -> { order 'id asc' }
  has_many :game_question_attempts
  enum delete_status: [ :active, :deleted ]
  enum approval_status: [ :not_approved, :primary_approved, :secondary_approved ]
  has_many :hints, as: :acad_entity

  def proportion_blocks
    game_options_list = []
    sub_question_id_list = sub_questions.map{|x|x.id}
    sub_questions.each do |s_q|
      option_i = 0
      s_q.game_options.each do |g_o|
        option_i = option_i +1
        game_options_list  << g_o.option.slice(:id, :display, :hint, :title, :value_type)
        game_options_list.last[:key] = sub_question_id_list.index(g_o.game_question.id)+1
        game_options_list.last[:_key] =  "sequence,1,2,3,4,5,6"
        game_options_list.last[:value] = g_o.option.display
        game_options_list.last[:option_index] = option_i
        game_options_list.last[:_option_index] =  "sequence,1,2,3,4,5,6"
      end
    end
    gr_list = game_options_list.group_by { |d| d[:option_index] }
    new_list = []
    gr_list.each do |key,value|
      new_list << { title: value[0][:title],
        type: value[0][:value_type],
        _type: "dropdown,sector,math,text",
        faces: value,
        options: value}
    end
    return new_list
  end

  def correct_game_options
    game_options.reject { |g_o| !g_o.option.correct }
  end

  def incorrect_game_options
    game_options.reject { |g_o| g_o.option.correct }
  end

  def create_attempt_data question_obj, game_session
    ques_attempt = game_question_attempts.create!(time_attempt: Time.now, game_session: game_session)
    ques_attempt.set_attempt_score(question_obj)
  end

  def linked_game_holder
    return game_holder if !game_holder.nil?
    return parent_question.game_holder if !parent_question.nil?
  end

  def game_details
    return nil if linked_game_holder.nil?
    return Api::V1::PracticeQuestions::GameHolderDetailSerializer.new(linked_game_holder).as_json[:game_holder_detail]
  end

  def details
    return nil if linked_game_holder.nil?
    case linked_game_holder.game.slug
    when "agility"
      return get_agility_question_details
    when "conversion"
      return get_conversion_question_details
    when "diction"
      return get_diction_question_details
    when "discounting"
      return get_discounting_question_details
    when "division"
      get_division_question_details
    when "estimation"
      get_estimation_question_details
    when "inversion"
      get_inversion_question_details
    when "percentages"
      return get_percentages_question_details
    when "proportion"
      return get_proportion_question_details
    when "purchasing"
      return get_purchasing_question_details
    when "refinement"
      return get_refinement_question_details
    when "tipping"
      return get_tipping_question_details
    when "dragonbox"
      return get_dragonbox_question_details
    else
      get_scq_question_details
    end
  end

  # SCQ
  def get_scq_question_details
    Api::V1::PracticeQuestions::DivisionQuestionSerializer.new(self).as_json[:division_question]
  end

  # Agility
  def get_agility_question_details
    Api::V1::PracticeQuestions::AgilityQuestionSerializer.new(self).as_json[:agility_question]
  end

  # Conversion
  def get_conversion_question_details
    return Api::V1::PracticeQuestions::ConversionQuestionSerializer.new(self).as_json[:conversion_question]
  end

  # Diction
  def get_diction_question_details
    Api::V1::PracticeQuestions::DictionQuestionSerializer.new(self).as_json[:diction_question]
  end

  # Discounting
  def get_discounting_question_details
    Api::V1::PracticeQuestions::DiscountingQuestionSerializer.new(self).as_json[:discounting_question]
  end

  # Division
  def get_division_question_details
    Api::V1::PracticeQuestions::DivisionQuestionSerializer.new(self).as_json[:division_question]
  end

  # Estimation
  def get_estimation_question_details
    Api::V1::PracticeQuestions::EstimationQuestionSerializer.new(self).as_json[:estimation_question]
  end

  # Inversion
  def get_inversion_question_details
    Api::V1::PracticeQuestions::InversionQuestionSerializer.new(self).as_json[:inversion_question]
  end

  # Percentages
  def get_percentages_question_details
    Api::V1::PracticeQuestions::PercentagesQuestionSerializer.new(self).as_json[:percentages_question]
  end

  # Proportion
  def get_proportion_question_details
    Api::V1::PracticeQuestions::ProportionQuestionSerializer.new(self).as_json[:proportion_question] if parent_question
    Api::V1::PracticeQuestions::ProportionSectionSerializer.new(self).as_json[:proportion_section]
  end

  # Purchasing
  def get_purchasing_question_details
    Api::V1::PracticeQuestions::PurchasingQuestionSerializer.new(self).as_json[:purchasing_question]
  end

  # Refinement
  def get_refinement_question_details
    return Api::V1::PracticeQuestions::RefinementBlockSerializer.new(self).as_json[:refinement_block] if parent_question
    return Api::V1::PracticeQuestions::RefinementQuestionSerializer.new(self).as_json[:refinement_question]
  end

  # Tipping
  def get_tipping_question_details
    Api::V1::PracticeQuestions::TippingQuestionSerializer.new(self).as_json[:tipping_question]
  end

  # Dragonbox
  def get_dragonbox_question_details
    Api::V1::PracticeQuestions::DragonboxQuestionSerializer.new(self).as_json[:dragonbox_question]
  end

  def update_content(params)
    if question
      question_params = {}
      # Special provision as diction answer comes as its option
      diction_question_update_check(params)
      params = Question.remove_question_fields(params)
      Question.attribute_mapping.each do | game_question_key, question_key  |
        question_params[question_key] = params[game_question_key] if !params[game_question_key].nil?
      end
      question.update_attributes(question_params)
      return question
    end
    return nil
  end

  def create_child_question(params)
    game_question = GameQuestion.create_game_question(params, linked_game_holder, false)
    game_question.update_attributes!(parent_question: self)
    raise ArgumentError.new("Game Question couldn't be created") if game_question.nil?
    return game_question
  end

  def self.create_complete_question(game_holder, params)
    parent_game_question = GameQuestion.create_game_question(params, game_holder, true)
    if params["blocks"]
      params["blocks"].each do |block_params|
        parent_game_question.create_child_question(block_params)
      end
    end
    return parent_game_question
  end

  def self.create_game_question params, game_holder, is_parent
    question = Question.create_content(params, game_holder, is_parent)
    raise ArgumentError.new("Question couldn't be created") if question.nil?
    game_question = GameQuestion.create!(question: question, game_holder: game_holder)
    GameOption.create_game_option(game_question,params)
    return game_question
  end

  def diction_question_update_check(params)
    if linked_game_holder.game.slug == "diction"
      if params.has_key?("answer")
        game_options.first.option.update_attributes(correct: params["answer"]) if game_options.count > 0
      end
    end
  end
end
