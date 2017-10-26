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
  has_many :user_regions

  enum sex: [ :male, :female ]
  enum registration_method: [ :mobile, :email, :social ]
  # attr_accessor :first_name, :last_name, :email
  def to_s
    "#{self.first_name} #{self.last_name}"
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
  private
  def set_default_role
    self.role ||= Role.find_by_name('student')
  end
end
