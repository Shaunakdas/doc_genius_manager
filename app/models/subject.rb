class Subject  < AcadEntity

  has_many :streams
  has_many :chapters, through: :streams
  has_many :topics, through: :chapters
  has_many :sub_topics, through: :topics
  has_many :question_types, through: :sub_topics
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
  has_many :acad_entity_scores, as: :acad_entity
  has_many :region_percentile_scores, as: :acad_entity
end
