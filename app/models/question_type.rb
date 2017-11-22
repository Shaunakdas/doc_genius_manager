class QuestionType < AcadEntity
  belongs_to :sub_topic
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}, :allow_blank => true
  has_many :game_holders, -> { order('game_holders.sequence') }
  has_many :games, -> { order('game_holders.sequence') }, through: :game_holders, source_type: "WorkingRule"
  # scope :recent, -> { order('question_type.id ASC').limit(2) }

  has_many :game_sessions, -> { order('game_sessions.id DESC') }, through: :game_holders
  has_many :session_scores, -> { order('game_sessions.id DESC') }, through: :game_sessions
  has_many :game_sessions, through: :game_holders
  has_many :session_scores, through: :game_sessions

  def self.list(list_params)
    question_type_list = QuestionType.all
    if list_params["search"]
      query = list_params["search"]
      question_type_list = QuestionType.search(list_params[:search]).order('created_at DESC')
    elsif list_params["slug"]
      query = list_params["slug"]
      question_type_list = QuestionType.search_slug(list_params[:slug]).order('created_at DESC')
    end
    total_count = question_type_list.count
    page_num = (list_params.has_key?("page"))? (list_params["page"].to_i-1):(0)
    limit = (list_params.has_key?("limit"))? (list_params["limit"].to_i):(10)
    question_type_list = question_type_list.drop(page_num * limit).first(limit)
    list_response = {result: question_type_list, page: page_num+1, limit: limit, total_count: total_count, search: query}
  end
end
