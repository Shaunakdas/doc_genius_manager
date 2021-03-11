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
  has_many :practice_game_holders, through: :streams, as: :acad_entity, class_name: "GameHolder"

  def child_entities standard_group
    return Standard.all if standard_group.nil?
    return Standard.where(slug: ["1","2","3","4"]).order("sequence DESC") if standard_group == "junior"
    return Standard.where(slug: ["5","6","7","8"]).order("sequence DESC") if standard_group == "middle"
    return Standard.where(slug: ["9","10","11","12"]).order("sequence DESC") if standard_group == "senior"
  end

  def standard_game_holders standard
    return [] if game_holders.count == 0 && practice_game_holders.count == 0
    practice_types = PracticeType.where(slug: ['agility','purchasing','conversion','discounting','inversion'])
    standard_chaps = chapters.where(enabled: true).where(standard: standard).order('random()')
    return game_holders.where(:game_id => practice_types.map(&:id)).last(5) if standard_chaps.count == 0

    # Check for practice game holders in each chapter
    standard_game_holders = standard_chaps.first.practice_game_holders
    game_list = standard_game_holders.where(:game_id => practice_types.map(&:id)).last(5) if standard_game_holders.count > 0
    return game_list if game_list.length > 5 || standard_chaps.length == 1
    next_game_holders = standard_chaps.second.practice_game_holders
    game_list = game_list + next_game_holders.where(:game_id => practice_types.map(&:id)).last(5) if next_game_holders.count > 0
    return game_list.first(5) if game_list.length > 5
    return []
  end
end
