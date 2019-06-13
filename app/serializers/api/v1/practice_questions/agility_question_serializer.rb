module Api::V1::PracticeQuestions
  class AgilityQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: AgilityOptionSerializer)
    end

    def hint
      object.question.solution
    end
  end
end