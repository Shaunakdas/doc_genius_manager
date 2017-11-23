module Api::V1
  class QuestionTypeShowSerializer < AcadEntitySerializer
    attributes :sub_topic, :sequence, :top_score, :challenges, :scores,:benifits
    has_one :sub_topic, serializer: SubTopicSerializer
    has_many :benifits, serializer: BenifitSerializer
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