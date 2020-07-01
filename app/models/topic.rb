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

  def next_chapter_topic
    enabled_topics = chapter.practice_topics
    current_index = enabled_topics.index(self)+1
    return nil if enabled_topics.length == current_index
    return enabled_topics[current_index]
  end

  def set_fresh_standing user
    set_attempt_standing(user)
    level_standing = user.level_standing
    if level_standing.nil?
      level_standing = AcadStanding.new(acad_entity: practice_game_levels.first, user: user).save!
    elsif level = TopicLevelStanding.where(user: user, topic: self).first
      level_standing.update_attributes!(acad_entity: level.game_level)
    else
      level_standing.update_attributes!(acad_entity: practice_game_levels.first)
    end
  end

  def set_attempt_standing user
    topic_standing = user.topic_standing
    if topic_standing.nil?
      topic_standing = AcadStanding.new(acad_entity: self, user: user).save!
    else
      topic_standing.update_attributes!(acad_entity: self)
    end
  end

  def set_level_standing level,user
    # Only to be used after game attempt with more than 1 star rating
    level_standings = TopicLevelStanding.where(topic: self, user: user)
    if level_standings.count == 0
      level_standing = TopicLevelStanding.new(topic: self, game_level: level, user: user)
      level_standing.save!
    else
      level_standing = level_standings.first
      level_standing.update_attributes!(game_level: level, jump: true)
    end
  end

  def reset_jump user
    level_standings = TopicLevelStanding.where(topic: self, user: user, jump: true)
    if level_standings.count > 0
      level_standings.first.update_attributes!(jump: false)
      return true
    end
    return false
  end


  def background_list
    {
      1 => "green_forest",
      2 => "coniferous",
      3 => "desert",
      6 => "jungle",
      7 => "crystal",
      8 => "swamp",
      12 => "bamboo_forest",
      13 => "tundra",
    }
  end

  def background_area
    return background_list[id]
  end
end
