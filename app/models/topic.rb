class Topic < AcadEntity
  belongs_to :chapter
  has_many :sub_topics
end
