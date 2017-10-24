class Topic < AcadEntity
  belongs_to :chapter
  has_many :sub_topics
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
end
