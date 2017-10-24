class Chapter < AcadEntity
  belongs_to :standard
  belongs_to :stream
  has_many :topics
end
