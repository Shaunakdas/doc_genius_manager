class SubTopic < AcadEntity
  belongs_to :topic
  has_many :question_types
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
end
