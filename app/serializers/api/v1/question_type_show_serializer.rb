module Api::V1
  class QuestionTypeShowSerializer < AcadEntitySerializer
    attributes :sub_topic, :sequence, :top_score, :challenges, :scores
    attribute :display_benifits, key: :benifits
    has_one :sub_topic, serializer: SubTopicSerializer
    
    def top_score
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