class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable,
  #        :confirmable, :lockable
  # validates_presence_of :email
  # validates_uniqueness_of :email, case_sensitive: false
  # validates_format_of :email, with: /@/ 

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

  has_many :game_holder_actions
  has_many :liked_game_holder_actions , -> { where(action_type: :like) }, class_name: 'GameHolderAction'
  has_many :liked_game_holders , through: :liked_game_holder_actions, source: :game_holder
  has_many :saved_game_holder_actions , -> { where(action_type: :save_action) }, class_name: 'GameHolderAction'
  has_many :saved_game_holders , through: :saved_game_holder_actions, source: :game_holder

  has_many :user_game_themes
  has_many :saved_game_themes , through: :user_game_themes, source: :game_theme

  # scope :male, where(sex: :male)
  # attr_accessor :first_name, :last_name, :email
  def to_s
    "#{self.first_name} #{self.last_name}"
  end

  def email_required?
    false
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

  def game_difficulty_index game_holder
    last_session = game_sessions.where(game_holder: game_holder).last
    if last_session && last_session.next_difficulty_index > 0
      return last_session.next_difficulty_index
    else
      return game_holder.game_questions.minimum(:difficulty_index)
    end
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
    [standard, first_chapter, first_topic].each { |entity| entity.acad_profiles.create!(user_id: self.id) if entity }
  end

  def last_attempt_time
    return nil if game_sessions.count == 0
    return game_sessions.last.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def check_for_game_holders(chapter,topic)
    if chapter && topic.practice_game_holders.length == 0
      return chapter.topics.where(
        sequence: chapter.topics.minimum(:sequence)+1
        ).first 
    else
      return topic
    end
  end
  
  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def top_sessions(game_holder, count)
    game_sessions.where(game_holder: game_holder).sort_by {|ses| ses.total_score}.reverse!.first(count)
  end

  def recent_sessions(game_holder, count)
    game_sessions.where(game_holder: game_holder).sort_by {|ses| ses.start}.reverse!.first(count)
  end

  def time_spent(game_holder)
    game_sessions.where(game_holder: game_holder).to_a.sum(&:time_spent)
  end


  def self.twilio_client
    account_sid = 'AC2d2b007e1adae1c206d6d37757ad42e9'
    auth_token = '3805cff4c7892a22e22cf245c6a1d820'
    client = Twilio::REST::Client.new(account_sid, auth_token)
    return client
  end

  def send_otp mobile_number
    puts "Sending OTP"
    otp = generate_otp
    update_attributes!(otp: otp)
    if Rails.env.production? 
      message = "OTP for Gurukul of Drona is: #{otp}. "
      from = '+12023353127'
      User.twilio_client.messages.create(from: from, to: "+91#{mobile_number}", body: message)
    end
    return otp
  end

  def self.mobile_create_validate mobile_number, username
    error_code = 0
    errored = false
    send_otp = true
    error_msg = ""
    user=nil
    otp = ""
    
    if mobile_number.nil? || username.nil?
      errored = true
      error_code = 1
      error_msg = "We need both mobile_number and username for login"

    elsif !validate_mobile(mobile_number)
      # First check for mobile_number datatype
      errored = true
      error_code = 2
      error_msg = "Your mobile number is not valid."

    elsif !validate_usr(username)
      # Second check for username data
      errored = true
      error_code = 3
      error_msg = "Your username is not valid. Kindly ensure that username has atleast 4 characters and atmost 16 characters."

    elsif user = User.find_by(mobile_number: mobile_number)
      # Mobile exists, ignore username - search using mobile - Send OTP
      otp = user.send_otp(mobile_number)

    elsif user = User.find_by(username: username)
      # Mobile doesn't exist, username exists - Error
      errored = true
      error_code = 4
      error_msg = "This username already exists. Kindly choose different username"
    
    else
      # Mobile doesn't exist, username doesn't exist - create using mobile - Send OTP
      user = User.create_mobile_user(username,mobile_number)
      otp = user.send_otp(mobile_number)
    end
    return {
      error_code: error_code,
      errored: errored,
      send_otp: !errored,
      error_msg: error_msg,
      user: user,
      otp: otp
    }
  end

  def self.generate_username
    prefix = ['arjun','bheem','nakul','sahadev','krishna'].sample
    suffix1 = rand(10000..99999)
    suffix2 = rand(10000..99999)
    suffix3 = rand(10000..99999)
    return "#{prefix}#{suffix1}" if User.where(username: "#{prefix}#{suffix1}").count == 0 
    return "#{prefix}#{suffix2}" if User.where(username: "#{prefix}#{suffix2}").count == 0 
    return "#{prefix}#{suffix3}" if User.where(username: "#{prefix}#{suffix3}").count == 0 
  end

  def self.create_mobile_user username, mobile_number
    u = User.create!(username: username, mobile_number: mobile_number)
    u.save!
    return u
  end

  def topic_standing
    standing = AcadStanding.where(acad_entity_type: "Topic", user: self).first
    return nil if standing.nil?
    return standing
  end

  def level_standing
    standing = AcadStanding.where(acad_entity_type: "GameLevel", user: self).first
    return nil if standing.nil?
    return standing
  end

  private

  def generate_otp
    rand(5 ** 5).to_s.rjust(4,'0') 
  end

  def generate_token
    SecureRandom.random_number(999999)  
  end

  def set_default_role
    self.role ||= Role.find_by_name('student')
  end

  def self.validate_usr username
    !!username[/\A\w{4,16}\z/]
  end

  def self.validate_mobile mobile_number
    !!mobile_number[/[5-9][0-9]{9}/]
  end
end
