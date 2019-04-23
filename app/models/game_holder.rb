class GameHolder < ApplicationRecord
  belongs_to :game, polymorphic: true
  belongs_to :question_type, optional: true
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}, :allow_blank => true
  belongs_to :acad_entity, polymorphic: true, optional: true

  validates_presence_of :slug
  validates_presence_of :name
  has_many :game_sessions

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

  def get_questions
    puts game.slug
    case game.slug
    when "agility"
      return get_scq_questions
    when "purchasing"
      return get_scq_questions
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
    when "percentages"
      return get_percentages_questions
    when "proportion"
      return get_proportion_questions
    when "tipping"
      return get_tipping_questions
    else
      get_scq_questions
    end
  end

  # SCQ
  def get_scq_questions

  end

  # Conversion
  def get_conversion_questions

  end

  # Diction
  def get_diction_questions
  end

  # Discounting
  def get_discounting_questions

  end

  # Division
  def get_division_questions
    Api::V1::PracticeQuestions::DivisionGameSerializer.new(self).as_json[:division_game]
  end

  # Inversion
  def get_inversion_questions

  end

  # Percentages
  def get_percentages_questions

  end

  # Proportion
  def get_proportion_questions

  end

  # Tipping
  def get_tipping_questions

  end
end
