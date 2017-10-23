class QuestionType < AcadEntity
  belongs_to :sub_topic
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}
end
