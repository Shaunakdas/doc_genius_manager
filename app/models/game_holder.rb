class GameHolder < ApplicationRecord
  belongs_to :game, polymorphic: true
  belongs_to :question_type, optional: true
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}, :allow_blank => true
  belongs_to :acad_entity, polymorphic: true, optional: true

  validates_presence_of :slug
  validates_presence_of :name
  has_many :game_sessions
  has_one :score_structure

  has_many :game_questions
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
    when "inversion"
      get_inversion_questions
    when "percentages"
      return get_percentages_questions
    when "proportion"
      return get_proportion_questions
    when "purchasing"
      return get_purchasing_questions
    when "tipping"
      return get_tipping_questions
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
  end

  # Discounting
  def get_discounting_questions
    Api::V1::PracticeQuestions::DiscountingGameSerializer.new(self).as_json[:discounting_game]
  end

  # Division
  def get_division_questions
    Api::V1::PracticeQuestions::DivisionGameSerializer.new(self).as_json[:division_game]
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

  # Tipping
  def get_tipping_questions
    Api::V1::PracticeQuestions::TippingGameSerializer.new(self).as_json[:tipping_game]
  end
end
