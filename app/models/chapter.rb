class Chapter < AcadEntity
  belongs_to :standard
  belongs_to :stream
  has_many :topics
  has_many :sub_topics, through: :topics
  has_many :question_types, through: :sub_topics
  has_many :game_holders, through: :question_types
  has_many :game_sessions, through: :game_holders
  has_many :session_scores, through: :game_sessions
  has_many :practice_game_holders, through: :topics, as: :acad_entity, class_name: "GameHolder"
  
  has_many :acad_profiles, as: :acad_entity
  has_many :acad_entity_scores, as: :acad_entity
  has_many :region_percentile_scores, as: :acad_entity
  has_many :users, through: :acad_profiles
end
