class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /@/

  validates_presence_of :first_name, :last_name
  belongs_to :role
  before_create :set_default_role
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

  private
  def set_default_role
    self.role ||= Role.find_by_name('student')
  end
end
