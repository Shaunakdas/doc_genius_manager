module Api::V1::PracticeQuestions
  class RefinementBlockSerializer < PracticeQuestionSerializer
    attributes :id, :question, :section_question, :time, :hint, :options

    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: RefinementOptionSerializer)
    end

    def time
      20
    end

    def hint
      object.question.solution
    end
  end
end