class AcadEntity < ApplicationRecord
  self.abstract_class = true
  validates_presence_of :slug
  validates_presence_of :name

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