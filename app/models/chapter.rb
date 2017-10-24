class Chapter < AcadEntity
  belongs_to :standard
  belongs_to :stream
  has_many :topics
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
end
