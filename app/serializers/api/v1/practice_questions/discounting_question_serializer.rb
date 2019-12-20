module Api::V1::PracticeQuestions
  class DiscountingQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :solution, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: DiscountingOptionSerializer)
    end

    def hint
      object.question.solution
    end
  end
end