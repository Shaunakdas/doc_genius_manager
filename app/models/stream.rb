class Stream  < AcadEntity
  belongs_to :subject
  has_many :chapters
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
  has_many :acad_entity_scores, as: :acad_entity
end
