class Standard < ApplicationRecord
  validates_presence_of :slug
  validates_presence_of :name

  def to_s
    "#{self.name}"
  end

  def self.search(search)
    where('name LIKE :search', search: "%#{search}%")
  end
end
