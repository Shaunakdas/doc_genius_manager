class QuestionType < AcadEntity
  belongs_to :sub_topic
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}
  has_many :game_holders, -> { order('game_holders.sequence') }
  has_many :games, -> { order('game_holders.sequence') }, through: :game_holders, source_type: "WorkingRule"
end
