module Api::V1
  class GameLevelDetailSerializer < GameLevelSerializer
    attributes  :benefits, :score, :sub_title, :question_input, :score_algo
  end
end
