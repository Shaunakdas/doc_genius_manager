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

  def question_types
    return standard.question_types
  end

  def recent_questions
    return standard.recent_questions
  end

  def update_acad_entity(params)
    if params.keys.count > 0
      acad_entity = AcadProfile.find_acad_entity(params)
      profile =  acad_entity.acad_profiles.create!(user_id: self.id)
    end
  end
  
  private
  def set_default_role
    self.role ||= Role.find_by_name('student')
  end
end
