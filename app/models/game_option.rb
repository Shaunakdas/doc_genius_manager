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

  def update_content(params)
    if option
      option_params = {}
      Option.attribute_mapping.each do | game_option_key, option_key  |
        option_params[option_key] = params[game_option_key] if !params[game_option_key].nil?
      end
      option.update_attributes(option_params)
      return option
    end
    return nil
  end

  def self.create_content(game_question, params)
    option = Option.create_content(params, game_question.linked_game_holder)
    game_option = GameOption.create!(option: option, game_question: game_question) if option
    return game_option if game_option
    return nil
  end

  def details
    return nil if (game_question.nil? || game_question.linked_game_holder.nil?)
    case game_question.linked_game_holder.game.slug
    when "agility"
      return get_agility_option_details
    when "conversion"
      return get_conversion_option_details
    when "diction"
      return get_diction_option_details
    when "discounting"
      return get_discounting_option_details
    when "division"
      get_division_option_details
    when "estimation"
      get_estimation_option_details
    when "inversion"
      get_inversion_option_details
    when "percentages"
      return get_percentages_option_details
    when "proportion"
      return get_proportion_option_details
    when "purchasing"
      return get_purchasing_option_details
    when "refinement"
      return get_refinement_option_details
    when "tipping"
      return get_tipping_option_details
    when "dragonbox"
      return get_dragonbox_option_details
    else
      get_scq_option_details
    end
  end

  # SCQ
  def get_scq_option_details
    Api::V1::PracticeQuestions::DivisionOptionSerializer.new(self).as_json[:division_option]
  end

  # Agility
  def get_agility_option_details
    Api::V1::PracticeQuestions::AgilityOptionSerializer.new(self).as_json[:agility_option]
  end

  # Conversion
  def get_conversion_option_details
    return Api::V1::PracticeQuestions::ConversionOptionSerializer.new(self).as_json[:conversion_option]
  end

  # Diction
  def get_diction_option_details
    Api::V1::PracticeQuestions::DictionOptionSerializer.new(self).as_json[:diction_option]
  end

  # Discounting
  def get_discounting_option_details
    Api::V1::PracticeQuestions::DiscountingOptionSerializer.new(self).as_json[:discounting_option]
  end

  # Division
  def get_division_option_details
    Api::V1::PracticeQuestions::DivisionOptionSerializer.new(self).as_json[:division_option]
  end

  # Estimation
  def get_estimation_option_details
    Api::V1::PracticeQuestions::EstimationOptionSerializer.new(self).as_json[:estimation_option]
  end

  # Inversion
  def get_inversion_option_details
    Api::V1::PracticeQuestions::InversionOptionSerializer.new(self).as_json[:inversion_option]
  end

  # Percentages
  def get_percentages_option_details
    Api::V1::PracticeQuestions::PercentagesOptionSerializer.new(self).as_json[:percentages_option]
  end

  # Proportion
  def get_proportion_option_details
    Api::V1::PracticeQuestions::ProportionOptionSerializer.new(self).as_json[:proportion_option]
  end

  # Purchasing
  def get_purchasing_option_details
    Api::V1::PracticeQuestions::PurchasingOptionSerializer.new(self).as_json[:purchasing_option]
  end

  # Refinement
  def get_refinement_option_details
    Api::V1::PracticeQuestions::RefinementOptionSerializer.new(self).as_json[:refinement_option]
  end

  # Tipping
  def get_tipping_option_details
    Api::V1::PracticeQuestions::TippingOptionSerializer.new(self).as_json[:tipping_option]
  end

  # Dragonbox
  def get_dragonbox_option_details
    Api::V1::PracticeQuestions::DragonboxOptionSerializer.new(self).as_json[:dragonbox_option]
  end

  def self.create_game_option game_question,params
    GameOption.create_specific_options(game_question, params)
    if params["options"]
      params["options"].each do |option_params|
        game_option = GameOption.create_content(game_question, option_params)
        raise ArgumentError.new("GameOption couldn't be created") if game_option.nil?
      end
    end
  end



  # For creating game speicifc options
  def self.create_specific_options(game_question, params)
    return nil if game_question.game_holder.nil?
    case game_question.game_holder.game.slug
    when "diction"
      return self.create_diction_options(game_question, params)
    else
      return nil
    end
  end

  def self.create_diction_options(game_question, params)
    if params["answer"]
      option_params = {correct: params["answer"]}
      game_option = GameOption.create_content(game_question, option_params)
      raise ArgumentError.new("GameOption couldn't be created") if game_option.nil?
    end
  end
end
