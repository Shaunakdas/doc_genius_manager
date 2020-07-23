module Api::V1::PracticeQuestions
  class RefinementBlockSerializer < PracticeQuestionSerializer
    attributes :id, :question, :section_question, :time, :_time, :hint, :hint_structure, :solution, :options

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

    def hint_structure
      Question.parse_hint_structure(object.question.solution,object.question.prefix_url)
    end
  end
end