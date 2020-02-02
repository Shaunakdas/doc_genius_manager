module Api::V1
  class GameLevelDetailSerializer < GameLevelSerializer
    attributes  :benefits, :score, :sub_title, :question_input, :score_algo,
      :practice_mode, :nature_effect, :sequence, :intro_character_discussion, :success_character_discussion,
      :fail_character_discussion, :success_victory_cards
    has_one :intro_character_discussion, serializer: CharacterDiscussionSerializer
    has_one :success_character_discussion, serializer: CharacterDiscussionSerializer
    has_one :fail_character_discussion, serializer: CharacterDiscussionSerializer
    has_many :success_victory_cards, serializer: VictoryCardSerializer
  end
end
