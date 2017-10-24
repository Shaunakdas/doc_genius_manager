class WorkingRule < Game
  has_many :game_holders, as: :game
  has_many :question_types, through: :game_holders
end
