class GameHolder < ApplicationRecord
  belongs_to :game, polymorphic: true
  belongs_to :question_type
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}

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
end
