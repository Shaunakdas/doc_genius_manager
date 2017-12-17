class Stream  < AcadEntity
  belongs_to :subject
  has_many :chapters, -> { order('chapters.sequence_stream') }
  has_many :topics, -> { order('chapters.sequence_stream, topics.sequence') }, through: :chapters
  has_many :sub_topics,  -> { order('chapters.sequence_stream, topics.sequence, sub_topics.sequence') }, through: :topics
  has_many :question_types,  -> { order('chapters.sequence_stream, topics.sequence, sub_topics.sequence, question_types.sequence') }, through: :sub_topics
  has_many :game_holders, through: :question_types
  has_many :game_sessions, through: :game_holders
  has_many :session_scores, through: :game_sessions
  
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
  has_many :acad_entity_scores, as: :acad_entity
  has_many :region_percentile_scores, as: :acad_entity
end
