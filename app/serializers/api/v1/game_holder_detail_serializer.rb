module Api::V1
  class GameHolderDetailSerializer < GameHolderSerializer
    attributes  :benefits, :score, :sub_title, :question_input, :score_algo, :game_theme_payload
  end
end
