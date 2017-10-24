class SubTopic < AcadEntity
  belongs_to :topic
  has_many :question_types
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
  has_many :acad_entity_scores, as: :acad_entity
end
