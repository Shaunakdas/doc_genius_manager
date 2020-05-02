module Api::V1
  class GameLevelDetailSerializer < GameLevelSerializer
    attributes  :star_count, :chapter_sequence, :background_area ,:benefits, :score, :sub_title, :question_input, :score_algo,
      :practice_mode, :nature_effect, :sequence, :intro_character_discussion, :success_character_discussion,
      :fail_character_discussion, :final_victory_cards 
    has_one :intro_character_discussion, serializer: CharacterDiscussionSerializer
    has_one :success_character_discussion, serializer: CharacterDiscussionSerializer
    has_one :fail_character_discussion, serializer: CharacterDiscussionSerializer
    # has_many :success_victory_cards, serializer: GameLevelVictoryCardSerializer
    def chapter_sequence
      object.id
    end

    def background_area
      object.background_area
    end

    def final_victory_cards
      return [] if object.success_victory_cards.length == 0
      return [] if object.success_victory_cards[0].class.name != "GameLevelVictoryCard"
      return ActiveModel::ArraySerializer.new(object.success_victory_cards, each_serializer: GameLevelVictoryCardSerializer)
    end

    def star_count
      return nil if scope.nil?
      last_session = GameSession.where(user: scope, game_level:object).last
      return nil if last_session.nil?
      return last_session.attempt_score.star_count
    end
  end
end
