class GameHolder < ApplicationRecord
  belongs_to :game, polymorphic: true
  belongs_to :question_type, optional: true
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}, :allow_blank => true
  belongs_to :acad_entity, polymorphic: true, optional: true

  validates_presence_of :slug
  validates_presence_of :name
  has_many :game_sessions

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
end
