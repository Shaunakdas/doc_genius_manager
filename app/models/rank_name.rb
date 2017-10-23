class RankName < ApplicationRecord
  validates_presence_of :slug
  validates_presence_of :display_text

  def to_s
    "#{self.display_text}"
  end

  def self.search(search)
    where('display_text LIKE :search', search: "%#{search}%")
  end

  def self.search_slug(search)
    where('slug LIKE :search', search: "#{search}")
  end
end
