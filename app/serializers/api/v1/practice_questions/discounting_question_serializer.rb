module Api::V1::PracticeQuestions
  class DiscountingQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: DiscountingOptionSerializer)
    end
  end
end