class Subject  < AcadEntity

  has_many :streams
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
end
