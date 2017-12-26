module Api::V1
  class QuestionTypeShowSerializer < QuestionTypeSerializer
    attributes :best, :challenges, :scores,:benifits,:game_holder_id, :current
    # has_one :sub_topic, serializer: SubTopicSerializer
    has_many :benifits, serializer: BenifitSerializer
    has_one :current, serializer: GameSerializer

    def game_holder_id
      if ((object.game_holders.count > 0) && (object.game_holders[0].game))
        object.game_holders[0].id
      else
        nil
      end
    end

    def current
      if ((object.game_holders.count > 0) && (object.game_holders[0].game))
        object.game_holders[0].game
      else
        nil
      end
    end

    def best
      @options[:user].top_score(object) if @options[:user]
    end

    def challenges
      []
    end

    def scores
      @options[:user].display_scores(object) if @options[:user]
    end
  end
end