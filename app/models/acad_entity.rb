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
    return [] if game_holders.count == 0 && practice_game_holders.count == 0
    practice_types = PracticeType.where(slug: ['agility','purchasing','conversion','discounting','inversion'])
    return practice_game_holders.where(:game_id => practice_types.map(&:id)).last(5) if practice_game_holders.count > 0
    return game_holders.where(:game_id => practice_types.map(&:id)).last(5)
  end

  def title
    name.titleize
  end

  def practice_game_holders
    []
  end

end