module Api::V1
  class GameLevelDetailSerializer < GameLevelSerializer
    attributes  :star_count, :chapter_sequence, :background_area ,:benefits, :score, :sub_title, :question_input, :score_algo,
      :practice_mode, :nature_effect, :sequence, :intro_character_discussion, :success_character_discussion,
      :fail_character_discussion, :final_victory_cards, :dialog_audios, :dialog_images, :question_audios
    has_one :intro_character_discussion, serializer: CharacterDiscussionSerializer
    has_one :success_character_discussion, serializer: CharacterDiscussionSerializer
    has_one :fail_character_discussion, serializer: CharacterDiscussionSerializer
    # has_many :success_victory_cards, serializer: GameLevelVictoryCardSerializer
    def chapter_sequence
      object.id
    end

    def score
      session_list = []
      GameSession.joins(:attempt_score).where(user: scope, game_level: object).each do |ses|
        next if ses.attempt_score.nil?
        session_list << { id: ses.id, score: ses.attempt_score.total_value, date: ses.created_at,
          passed: ses.attempt_score.passed, time_spent: ses.attempt_score.time_spent}
      end
      top = session_list.sort_by{ |ses| ses[:score]}.reverse.map { |obj| obj[:score] }
      recent = session_list.sort_by{ |ses| ses[:score]}.reverse.map { |obj| obj[:score] }
      time_spent = session_list.inject(0){|sum,e| sum + e[:time_spent].to_i }
      wins = session_list.inject(0){|sum,e| sum + (e[:passed] && 1 || 0) }
      return {
        highest: top[0].to_i,
        difficulty: {
          current: 100,
          max: 400
        },
        time_trained: time_spent,
        wins: wins,
        top: top.first(10),
        recent: recent.first(6)
      }
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
      return nil if last_session.attempt_score.nil?
      return last_session.attempt_score.star_count
    end
  end
end
