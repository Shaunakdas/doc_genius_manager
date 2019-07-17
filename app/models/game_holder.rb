class GameHolder < ApplicationRecord
  belongs_to :game, polymorphic: true
  belongs_to :question_type, optional: true
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}, :allow_blank => true
  belongs_to :acad_entity, polymorphic: true, optional: true

  validates_presence_of :slug
  validates_presence_of :name
  has_many :game_sessions
  has_one :score_structure

  has_many :game_questions, -> { order 'id asc' }
  # has_many :questions, through: :game_questions

  def to_s
    "#{self.name}"
  end

  def self.search(search)
    where('name LIKE :search', search: "%#{search}%")
  end

  def self.search_slug(search)
    where('slug LIKE :search', search: "#{search}")
  end

  def acad_entities
    [ question_type,
      question_type.sub_topic,
      question_type.sub_topic.topic,
      question_type.sub_topic.topic.chapter,
      question_type.sub_topic.topic.chapter.standard,
      question_type.sub_topic.topic.chapter.stream,
      question_type.sub_topic.topic.chapter.stream.subject]
  end

  def remove_game_questions
    game_questions.each do |ques|
      ques.update_attributes!(game_holder: nil)
    end
  end

  def get_questions
    puts game.slug
    case game.slug
    when "agility"
      return get_agility_questions
    when "conversion"
      return get_conversion_questions
    when "conversion"
      return get_conversion_questions
    when "diction"
      return get_diction_questions
    when "discounting"
      return get_discounting_questions
    when "division"
      get_division_questions
    when "estimation"
      get_estimation_questions
    when "inversion"
      get_inversion_questions
    when "percentages"
      return get_percentages_questions
    when "proportion"
      return get_proportion_questions
    when "purchasing"
      return get_purchasing_questions
    when "refinement"
      return get_refinement_questions
    when "tipping"
      return get_tipping_questions
    when "dragonbox"
      return get_dragonbox_questions
    else
      get_scq_questions
    end
  end

  # SCQ
  def get_scq_questions
    Api::V1::PracticeQuestions::DivisionGameSerializer.new(self).as_json[:division_game]
  end

  # Agility
  def get_agility_questions
    Api::V1::PracticeQuestions::AgilityGameSerializer.new(self).as_json[:agility_game]
  end

  # Conversion
  def get_conversion_questions
    Api::V1::PracticeQuestions::ConversionGameSerializer.new(self).as_json[:conversion_game]
  end

  # Diction
  def get_diction_questions
    Api::V1::PracticeQuestions::DictionGameSerializer.new(self).as_json[:diction_game]
  end

  # Discounting
  def get_discounting_questions
    Api::V1::PracticeQuestions::DiscountingGameSerializer.new(self).as_json[:discounting_game]
  end

  # Division
  def get_division_questions
    Api::V1::PracticeQuestions::DivisionGameSerializer.new(self).as_json[:division_game]
  end

  # Estimation
  def get_estimation_questions
    Api::V1::PracticeQuestions::EstimationGameSerializer.new(self).as_json[:estimation_game]
  end

  # Inversion
  def get_inversion_questions
    Api::V1::PracticeQuestions::InversionGameSerializer.new(self).as_json[:inversion_game]
  end

  # Percentages
  def get_percentages_questions
    Api::V1::PracticeQuestions::PercentagesGameSerializer.new(self).as_json[:percentages_game]
  end

  # Proportion
  def get_proportion_questions
    Api::V1::PracticeQuestions::ProportionGameSerializer.new(self).as_json[:proportion_game]
  end

  # Purchasing
  def get_purchasing_questions
    Api::V1::PracticeQuestions::PurchasingGameSerializer.new(self).as_json[:purchasing_game]
  end

  # Refinement
  def get_refinement_questions
    Api::V1::PracticeQuestions::RefinementGameSerializer.new(self).as_json[:refinement_game]
  end

  # Tipping
  def get_tipping_questions
    Api::V1::PracticeQuestions::TippingGameSerializer.new(self).as_json[:tipping_game]
  end

  # Dragonbox
  def get_dragonbox_questions
    Api::V1::PracticeQuestions::DragonboxGameSerializer.new(self).as_json[:dragonbox_game]
  end

  def parse_result user, result_json
    session = GameSession.create!(user: user, start: Time.now, game_holder: self)
    session.parse_result(result_json)
    return session
  end

  def game_options
    list = []
    game_questions.each do |g_q|
      g_q.game_options.each do |g_o|
        list << g_o
      end
    end
    return list
  end

  def sub_questions
    list = []
    game_questions.each do |g_q|
      g_q.sub_questions.each do |s_q|
        list << s_q
      end
    end
    return list
  end
end
