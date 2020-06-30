class Topic < AcadEntity
  belongs_to :chapter
  has_many :sub_topics
  has_many :question_types, through: :sub_topics
  has_many :game_holders, through: :question_types
  has_many :game_sessions, through: :game_holders
  has_many :session_scores, through: :game_sessions
  
  has_many :acad_profiles, as: :acad_entity
  has_many :users, through: :acad_profiles
  has_many :acad_entity_scores, as: :acad_entity
  has_many :region_percentile_scores, as: :acad_entity
  has_many :practice_game_holders, -> { order(sequence: :asc) }, as: :acad_entity, class_name: "GameHolder"
  
  def practice_game_levels
    topic_game_levels = []
    practice_game_holders.each do |game_holder|
      enabled_game_levels = game_holder.game_levels.where(enabled: true)
      topic_game_levels = topic_game_levels.concat(enabled_game_levels)
    end
    return topic_game_levels
  end
end
