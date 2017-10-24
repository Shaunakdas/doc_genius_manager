class Chapter < AcadEntity
  belongs_to :standard
  belongs_to :stream
  has_many :topics
  has_many :acad_profiles, as: :acad_entity
  has_many :acad_entity_scores, as: :acad_entity
  has_many :region_percentile_scores, as: :acad_entity
  has_many :users, through: :acad_profiles
end
