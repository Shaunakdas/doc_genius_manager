class SessionScore < ApplicationRecord
  belongs_to :game_session
  has_many :acad_entity_scores
  validates :value,presence:true, numericality: {only_float: true}
  after_save :update_aggregates
  before_save :update_failed
  attr_accessor :time_passed
  
  def update_failed
    self.failed = !self.passed
  end

  def value=(val)
    write_attribute :value, val.to_f
  end

  def update_aggregates
    AcadEntityScore.update_aggregates(self)
  end

  def time_passed
    @time_passed=1
    return @time_passed
  end

end
