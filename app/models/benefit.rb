class Benefit < DisplayEntity
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}
end
