class Benifit < DisplayEntity
  # validates :image_url, format: {with: /\.(png|jpg)\Z/i}
  belongs_to :question_type, optional: true
  belongs_to :game_level, optional: true
end
