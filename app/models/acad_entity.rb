class AcadEntity < ApplicationRecord
  self.abstract_class = true
  validates_presence_of :slug
  validates_presence_of :name

  validates_uniqueness_of :slug

  def to_s
    "#{self.name}"
  end

  def self.search(search)
    where('name LIKE :search', search: "%#{search}%")
  end

  def self.search_slug(search)
    where('slug LIKE :search', search: "#{search}")
  end

  def url_suffix
    "&#{self.class.name.underscore}=#{slug}"
  end

  def sample_game_holders
    return [] if game_holders.count == 0
    game_holders.last(5)
  end

  def title
    name.titleize
  end

end