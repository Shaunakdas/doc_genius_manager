module Api::V1::PracticeQuestions
  class DiscountingQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :solution, :hint_structure, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: DiscountingOptionSerializer)
    end

    def hint
      object.question.solution
    end

    def hint_structure
      Question.parse_hint_structure(object.question.solution)
    end
  end
end