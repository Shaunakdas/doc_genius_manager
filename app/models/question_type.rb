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

  has_many :benifits, -> { order('benifits.sequence') }
  
  # def display_benifits
  #   if benifits.count == 0
  #     benefits = Benifit.all.order(:sequence)
  #   end
  #   return benefits
  # end

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

  def edit_working_rule id,question_text
    games.each do |game|
      if game.id == id
        game.question_text = question_text
        game.save!
      end
    end
  end

  def self.add_working_rule params
    # If question_type key is present, check for question_type with slugs of QuestionType
    if params['question_type']
      question_type = QuestionType.where(slug: params['question_type']['slug']).first
      if question_type
        # QuestionType already exists. 
      elsif params['sub_topic']
        # QuestionType doesn't exist. Will check for existence of SubTopic
        sub_topic = SubTopic.where(slug: params['sub_topic']['slug']).first
        question_type = QuestionType.new(name: params['question_type']['name'],
          slug: params['question_type']['slug'],
          sub_topic: sub_topic)
        question_type.save!
      end
      # Will create Working Rule
      working_rule = WorkingRule.new(name: params['working_rule']['name'],
          slug: params['working_rule']['slug'],
          question_text: params['working_rule']['question_text'],
          difficulty_level: DifficultyLevel.last)
      if working_rule.save!
        name = 'Game Holder for '+question_type.name
        game_holder = GameHolder.new(question_type: question_type,
          game: working_rule,
          name: name,
          slug: name.gsub(' ','-').downcase)
        game_holder.save!
      end
      return question_type
    end
  end
end
