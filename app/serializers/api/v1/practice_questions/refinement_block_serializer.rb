module Api::V1::PracticeQuestions
  class RefinementBlockSerializer < PracticeQuestionSerializer
    attributes :id, :question, :section_question, :time, :_time, :hint, :solution, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: RefinementOptionSerializer)
    end

    def time
      20
    end

    def _time
      "positive_integer"
    end

    def hint
      object.question.solution
    end
  end
end