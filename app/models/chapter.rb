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

  def remove_game_holders
    practice_game_holders.each do |g|
      g.update_attributes(acad_entity: nil)
    end
  end

  def self.list(list_params)
    chapter_list = Chapter.all
    if list_params["standard_id"]
      chapter_list = Chapter.where(standard_id: list_params["standard_id"]).order('sequence_standard ASC')
    elsif list_params["search"]
      query = list_params["search"]
      chapter_list = Chapter.search(list_params[:search]).order('created_at DESC')
    elsif list_params["slug"]
      query = list_params["slug"]
      chapter_list = Chapter.search_slug(list_params[:slug]).order('created_at DESC')
    end
    total_count = chapter_list.count
    page_num = (list_params.has_key?("page"))? (list_params["page"].to_i-1):(0)
    limit = (list_params.has_key?("limit"))? (list_params["limit"].to_i):(10)
    chapter_list = chapter_list.drop(page_num * limit).first(limit)
    list_response = {result: chapter_list, page: page_num+1, limit: limit, total_count: total_count, search: query}
  end


  def practice_game_levels
    chapter_game_levels = []
    practice_game_holders.each do |game_holder|
      chapter_game_levels = chapter_game_levels.concat(game_holder.game_levels)
    end
    return chapter_game_levels
  end
end
