class Stream  < AcadEntity
  belongs_to :subject
  has_many :chapters
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
end
