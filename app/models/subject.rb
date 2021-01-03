class Subject  < AcadEntity

  has_many :streams
  has_many :chapters, through: :streams
  has_many :topics, through: :chapters
  has_many :sub_topics, through: :topics
  has_many :question_types, through: :sub_topics
  has_many :game_holders, through: :question_types
  has_many :game_sessions, through: :game_holders
  has_many :session_scores, through: :game_sessions
  
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
  has_many :acad_entity_scores, as: :acad_entity
  has_many :region_percentile_scores, as: :acad_entity

  def child_entities
    Standard.all
  end
end
