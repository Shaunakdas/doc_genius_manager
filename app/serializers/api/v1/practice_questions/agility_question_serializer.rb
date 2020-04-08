module Api::V1::PracticeQuestions
  class AgilityQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :question, :hint, :solution, :options, :post_submit_text, :hint_structure

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: AgilityOptionSerializer)
    end

    def hint
      object.question.solution
    end

    def hint_structure
      Question.parse_hint_structure(object.question.solution)
    end
  end
end