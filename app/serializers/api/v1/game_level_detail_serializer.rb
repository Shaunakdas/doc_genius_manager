module Api::V1
  class GameLevelDetailSerializer < GameLevelSerializer
    attributes  :chapter_sequence, :background_area ,:benefits, :score, :sub_title, :question_input, :score_algo,
      :practice_mode, :nature_effect, :sequence, :intro_character_discussion, :success_character_discussion,
      :fail_character_discussion, :success_victory_cards
    has_one :intro_character_discussion, serializer: CharacterDiscussionSerializer
    has_one :success_character_discussion, serializer: CharacterDiscussionSerializer
    has_one :fail_character_discussion, serializer: CharacterDiscussionSerializer
    has_many :success_victory_cards, serializer: GameLevelVictoryCardSerializer
    def chapter_sequence
      object.id
    end

    def background_area
      object.background_area
    end
  end
end
