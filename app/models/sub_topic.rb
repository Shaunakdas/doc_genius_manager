class SubTopic < AcadEntity
  belongs_to :topic
  has_many :question_types
end
