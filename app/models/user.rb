class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :lockable
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /@/

  # validates_presence_of :first_name, :last_name
  # validates_uniqueness_of :mobile_number, case_sensitive: false
  belongs_to :role, optional: true
  before_create :set_default_role
  has_many :acad_profiles
  has_many :game_sessions
  has_many :session_scores, -> { order('session_scores.id ASC') }, through: :game_sessions
  has_many :user_regions
  has_many :acad_entity_scores

  enum sex: [ :male, :female ]
  enum registration_method: [ :mobile, :email, :social ]

  # scope :male, where(sex: :male)
  # attr_accessor :first_name, :last_name, :email
  def to_s
    "#{self.first_name} #{self.last_name}"
  end
  
  def acad_scores(acad_entity)
    session_scores & acad_entity.session_scores
  end
  
  def top_score(acad_entity)
    acad_entity_score = acad_entity_scores.find {|s| s.acad_entity == acad_entity }
    top_score = (acad_entity_score != nil)?(acad_entity_score.maximum):(0)
  end
  
  def display_scores(acad_entity)
    scores = acad_scores(acad_entity)
    display_scores = {}
    sorted = scores.sort_by {|obj| obj.created_at}.reverse
    display_scores[:recent] = sorted.first(3).as_json(only: [:value, :created_at])
    sorted = scores.sort_by {|obj| obj.value}.reverse
    display_scores[:top] = sorted.first(3).as_json(only: [:value, :created_at])
    return display_scores
  end

  def self.search(search)
    where('first_name LIKE :search OR last_name LIKE :search OR email LIKE :search', search: "%#{search}%")
  end

  def self.search_email(search)
    where('email LIKE :search', search: "#{search}")
  end

  # def send_otp
  #   if !self.is_verified
  #     puts "Sending OTP to #{self.mobile_number} with code #{self.verification_code}"
  #   end
  # end
  def map_enums params
    if params[:sex]
      params[:sex] = User.sexes.key(params[:sex].to_i)
    end
    if params[:registration_method]
      params[:registration_method] = User.registration_methods.key(params[:registration_method].to_i)
    end
  end

  def self.list(params)
    user_list = User.all
    if params["search"]
      query = params["search"]
      user_list = User.search(params[:search]).order('created_at DESC')
    elsif params["email"]
      query = params["email"]
      user_list = User.search_email(params[:email]).order('created_at DESC')
    end
    total_count = user_list.count
    page_num = (params.has_key?("page"))? (params["page"].to_i-1):(0)
    limit = (params.has_key?("limit"))? (params["limit"].to_i):(10)
    user_list = user_list.drop(page_num * limit).first(limit)
    list_response = {result: user_list, page: page_num+1, limit: limit, total_count: total_count, search: query}
  end

  def standard
    profile = self.acad_profiles.where(acad_entity_type: 'Standard').first
    if profile
      standard = Standard.find(profile.acad_entity_id)
    else
      return nil
    end
  end

  def chapter
    profile = self.acad_profiles.where(acad_entity_type: 'Chapter').first
    if profile
      chapter = Chapter.find(profile.acad_entity_id)
    else
      return nil
    end
  end

  def enabled_chapters
    standard.chapters.where(enabled: true).sort_by{|obj| obj.sequence_standard}
  end

  def topic
    profile = self.acad_profiles.where(acad_entity_type: 'Topic').first
    if profile
      topic = Topic.find(profile.acad_entity_id)
    else
      return nil
    end
  end

  def practice_game_holders
    topic.practice_game_holders
  end

  def question_types
    return standard.question_types
  end

  def recent_questions
    return standard.recent_questions
  end

  def update_acad_entity(params)
    if params.keys.count > 0
      acad_entity = AcadProfile.find_acad_entity(params)
      if (not profile = acad_entity.acad_profiles.find_by(user_id: self.id))
        setup_initial_acad_entities(acad_entity) if acad_entity.model_name.name == "Standard"
      end
    end
  end

  def setup_initial_acad_entities(standard)
    # Finding first chapter
    first_chapter = standard.chapters.where(
      sequence_standard: standard.chapters.minimum(:sequence_standard)
      ).first
    # Finding first topic
    first_topic = first_chapter.topics.where(
      sequence: first_chapter.topics.minimum(:sequence)
      ).first if first_chapter
    # Check if first_topic has any game_holders
    first_topic = check_for_game_holders(first_chapter,first_topic)
    [standard, first_chapter, first_topic].each { |entity| entity.acad_profiles.create!(user_id: self.id) }
  end

  def check_for_game_holders(chapter,topic)
    return chapter.topics.where(
      sequence: chapter.topics.minimum(:sequence)+1
      ).first if chapter && topic.practice_game_holders.length == 0
  end
  
  private
  def set_default_role
    self.role ||= Role.find_by_name('student')
  end
end
