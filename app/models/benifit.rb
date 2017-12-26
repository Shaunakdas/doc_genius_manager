class Benifit < DisplayEntity
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}
  belongs_to :question_type
end
