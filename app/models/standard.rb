class Standard < AcadEntity
  
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

  def self.list(list_params)
    standard_list = Standard.all
    if list_params["search"]
      query = list_params["search"]
      standard_list = Standard.search(list_params[:search]).order('created_at DESC')
    elsif list_params["slug"]
      query = list_params["slug"]
      standard_list = Standard.search_slug(list_params[:slug]).order('created_at DESC')
    end
    total_count = standard_list.count
    page_num = (list_params.has_key?("page"))? (list_params["page"].to_i-1):(0)
    limit = (list_params.has_key?("limit"))? (list_params["limit"].to_i):(10)
    standard_list = standard_list.drop(page_num * limit).first(limit)
    list_response = {result: standard_list, page: page_num+1, limit: limit, total_count: total_count, search: query}
  end

  def recent_questions
    question_types.sort_by { |v| v[:id] }[0..3]
    # question_types
  end

  def streamwise_questions
    streams = []
    chapters.each do |chapter|
      stream = chapter.stream.slice(:id, :name, :slug, :sequence)
      stream[:question_types] = chapter.stream.question_types.map { |h| h.slice(:id, :slug, :name, :sequence, :image_url) }
      streams << stream
    end
    return streams
  end

  # def question_types(list_params)
  #   question_types = self.question_types
  #   total_count = question_types.count
  #   page_num = (list_params.has_key?("page"))? (list_params["page"].to_i-1):(0)
  #   limit = (list_params.has_key?("limit"))? (list_params["limit"].to_i):(10)
  #   question_types = question_types.drop(page_num * limit).first(limit)
  #   list_response = {result: question_types, page: page_num+1, limit: limit, total_count: total_count, search: query}
  # end
end
